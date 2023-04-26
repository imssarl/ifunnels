<?php

define('BASE_MARKUP_PATH', Zend_registry::get('config')->path->absolute->pagebuilder . 'elements' . DIRECTORY_SEPARATOR . 'skeleton.html');

class Project_Pagebuilder_Markup
{
    private $modal_markup = '<div class="modal fade" tabindex="-1" role="dialog"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button><div class="modal-dialog modal-lg" role="document"><div class="modal-content"><div class="modal-body"></div></div></div></div>';
    private $domXpath     = null;

    private $document   = null;
    private $defaultDom = array();

    private $addCss          = array();
    private $addJs           = array();
    private $addScript       = '';
    private $customUserJsCss = array();

    private $styles    = array();
    private $scripts   = array();
    private $cssFiles  = array();
    private $jsFiles   = array();
    private $jsonFiles = array();

    private $imageFiles = array();
    private $fontFiles  = array();
    private $config     = array();

    public function __construct($config = array())
    {
        $this->document = new DOMDocument;
        $this->config   = $config;

        $this->init();
    }

    /** Inital function */
    private function init()
    {
        /** Getting base markup */
        if ($this->document->loadHTMLFile(BASE_MARKUP_PATH)) {
            $this->defaultDom['container'] = $this->document->getElementById('page');
            $this->defaultDom['popups']    = $this->document->getElementById('popups');
            $this->defaultDom['head']      = $this->document->getElementsByTagName('head')->item(0);
            $this->defaultDom['body']      = $this->document->getElementsByTagName('body')->item(0);

            $this->domXpath = new DOMXpath($this->document);
            $this->replaceBasePath();
            $this->addBaseTag($this->config['url']);
        }
    }

    /** Setter AddCss */
    public function AddCss($css)
    {
        if (!empty($css)) {
            $this->addCss = $css;
        }

        return $this;
    }

    /** Setter AddJs */
    public function AddJs($js)
    {
        if (!empty($js)) {
            $this->addJs = $js;
        }

        return $this;
    }

    /** Setter AddScript */
    public function AddScript($js)
    {
        if (!empty($js)) {
            $this->addScript .= $js;
        }

        return $this;
    }

    /** Setter customUserJsCss */
    public function CustomUserCssJs($custom)
    {
        if (!empty($custom)) {
            $this->customUserJsCss = $custom;
        }

        return $this;
    }

    /** Replace base path for <link>, <script> tags */
    private function replaceBasePath()
    {
        foreach ($this->domXpath->query('//*[@src]') as $node) {
            $node->parentNode->removeChild($node);
            $this->jsFiles[] = Zend_Registry::get('config')->path->html->pagebuilder . 'elements/' . $node->getAttribute('src');
        }

        foreach ($this->domXpath->query('//*[@href]') as $node) {
            $node->parentNode->removeChild($node);
            $this->cssFiles[] = Zend_Registry::get('config')->path->html->pagebuilder . 'elements/' . $node->getAttribute('href');
        }
    }

    /** Added <base /> tag in markup */
    private function addBaseTag($url)
    {
        $baseNode = $this->document->createElement('base');
        $baseNode->setAttribute('href', sprintf('//%s%s', parse_url($url, PHP_URL_HOST), parse_url($url, PHP_URL_PATH)));

        $this->defaultDom['head']->insertBefore($baseNode, $this->defaultDom['head']->childNodes->item(0));
    }

    /** Generate block markup */
    public function addPartial($html)
    {
        $partialDom = new DOMDocument;

        if ($partialDom->loadHTML($html)) {
            $this->parsingEffectBlocks($partialDom);

            $domXpath = new DOMXpath($partialDom);

            /** Added all CSS files in a default DOM */
            foreach ($partialDom->getElementsByTagName('link') as $link) {
                if (!in_array($link->getAttribute('href'), $this->cssFiles)) {
                    $this->cssFiles[] = $link->getAttribute('href');
                }
            }

            /** Added all CSS files in a default DOM */
            foreach ($partialDom->getElementsByTagName('style') as $style) {
                // $this->defaultDom['head']->appendChild( $this->document->importNode( $style, true ) );
                if (empty($style->getAttribute('data-variants'))) {
                    if (!in_array($style->childNodes->item(0)->nodeValue, $this->styles)) {
                        $this->styles[] = trim($style->childNodes->item(0)->nodeValue);
                    }
                }
            }

            /** Added all JS code & files in a default DOM */
            foreach ($partialDom->getElementsByTagName('script') as $script) {
                if (!empty($script->getAttribute('src'))) {
                    if (!in_array($script->getAttribute('src'), $this->jsFiles)) {
                        // $this->defaultDom['body']->appendChild( $this->document->importNode( $script ) );
                        $this->jsFiles[] = $script->getAttribute('src');
                    }
                } else {
                    if ($script->getAttribute('type') !== 'application/json' && !in_array($script->childNodes->item(0)->nodeValue, $this->scripts)) {
                        $this->scripts[] = $script->childNodes->item(0)->nodeValue;
                    }

                    // $this->defaultDom['body']->appendChild( $this->document->importNode( $script, true ) );
                }
            }

            foreach ($domXpath->query('//div[contains(@class, "videoWrapper")]') as $element) {
                $element->setAttribute('class', $element->getAttribute('class') . ' onpublish');
            }

            if ($domXpath->query('//div[@data-component="countdown"]')->length > 0) {
                $this->jsFiles[] = Zend_Registry::get('config')->path->html->pagebuilder . 'build/flipobj.bundle.js';
            }

            $this->parsingCodeBlock($partialDom);

            // NFT Component
            $nftNode = $domXpath->query('//div[@data-component="nft"]');
            if ($nftNode->length > 0) {
                try {
                    $this->parsingNFT($nftNode->item(0));
                } catch (Exception $e) {
                    return Core_Data_Errors::getInstance()->setError("<b>NFT Component:</b> " . $e->getMessage());
                }
            }

            /** Added all markup in a default DOM */
            foreach ($partialDom->getElementById('page')->childNodes as $node) {
                $this->defaultDom['container']->appendChild($this->document->importNode($node, true));
            }
        }
    }

    private function parsingNFT($node)
    {
        $config = $node->getElementsByTagName('script');

        $links_to_remove = [];
        foreach ($config as $link) {
            $links_to_remove[] = $link;
        }

        foreach ($config as $item) {
            if ($item->getAttribute('type') === 'application/json') {
                $name = $item->getAttribute('data-type');
                $json = $item->textContent;

                $this->jsonFiles[] = [
                    'name' => $name,
                    'code' => $json,
                ];

                if ($name == 'config') {
                    $json = json_decode($json);

                    $this->jsonFiles[] = [
                        'name' => 'abi',
                        'code' => Project_Pagebuilder_NFT::getABI((int) $json->network, $json->contract_address),
                    ];
                }
            } else {
                continue;
            }
        }

        foreach ($links_to_remove as $link) {
            $link->parentNode->removeChild($link);
        }

        $this->jsFiles[] = '/skin/nft/dist/bundle.js';
    }

    public function parsingTestAB($status)
    {
        $domXpath = new DOMXPath($this->document);

        foreach ($domXpath->query('//*[@data-variant-name]') as $node) {
            $classList = array_filter(explode(' ', $node->getAttribute('class')), function ($class) {
                return $class !== 'hidden';
            });

            $node->setAttribute('class', join(' ', $classList));

            if (!$status) {
                if ($node->getAttribute('data-variant-name') === Project_Pagebuilder_TestAB::DEFAULT_OPTION) {
                    $node->removeAttribute('data-variant-name');
                    $node->removeAttribute('data-variant-show');
                } else {
                    $node->parentNode->removeChild($node);
                }
            }
        }

        if ($status) {
            $this->cssFiles[] = 'https://fasttrk.net/services/testab.css.php';
            $this->jsFiles[]  = Zend_Registry::get('config')->path->html->pagebuilder . 'build/testab.bundle.js';
        }
    }

    /** Generate Modal markup */
    public function addModal($html, $params = array())
    {
        $modalContainer = new DOMDocument;
        $modalContainer->loadHTML($this->modal_markup, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);

        $containerXpath     = new DOMXpath($modalContainer);
        $modalContainerNode = $containerXpath->query('//div[@class="modal-body"]')->item(0);

        $modalHtml = new DOMDocument;
        if ($modalHtml->loadHTML($html)) {
            $this->parsingEffectBlocks($modalHtml);

            $htmlXpath = new DOMXpath($modalHtml);
            foreach ($htmlXpath->query('//div[@class="modal-body"]')->item(0)->childNodes as $node) {
                $modalContainerNode->appendChild($modalContainer->importNode($node, true));
            }

            /** Added all CSS files in a default DOM */
            foreach ($modalHtml->getElementsByTagName('link') as $link) {
                if (!in_array($link->getAttribute('href'), $this->cssFiles)) {
                    $this->cssFiles[] = $link->getAttribute('href');
                }
            }

            /** Added all JS code & files in a default DOM */
            foreach ($modalHtml->getElementsByTagName('script') as $script) {
                if (!empty($script->getAttribute('src'))) {
                    if (!in_array($script->getAttribute('src'), $this->jsFiles)) {
                        // $this->defaultDom['body']->appendChild( $this->document->importNode( $script ) );
                        $this->jsFiles[] = $script->getAttribute('src');
                    }
                } else {
                    if (!in_array($script->childNodes->item(0)->nodeValue, $this->scripts)) {
                        $this->scripts[] = $script->childNodes->item(0)->nodeValue;
                    }
                }
            }
        }

        $modalNode = $modalContainer->childNodes->item(0);

        if ($params['popup'] === 'entry') {
            $modalNode->setAttribute('data-popup', 'entry');
        } else if ($params['popup'] === 'exit') {
            $modalNode->setAttribute('data-popup', 'exit');
        }

        if (!empty($params['popup_settings'])) {
            $settings = json_decode($params['popup_settings'], true);

            if (isset($settings['popupReoccurrence'])) {
                if ($settings['popupReoccurrence'] == 'Once') {
                    $modalNode->setAttribute('data-popup-occurrence', 'once');
                } else if ($settings['popupReoccurrence'] == 'All') {
                    $modalNode->setAttribute('data-popup-occurrence', 'all');
                }

            }

            if (isset($settings['popupDelay'])) {
                $modalNode->setAttribute('data-popup-delay', $settings['popupDelay']);
            }

            if ($params['popup'] === 'regular' && isset($settings['popupID'])) {
                $modalNode->setAttribute('id', $settings['popupID']);
            }
        }

        $modalNode->setAttribute('data-popup-id', $params['id']);
        $this->defaultDom['popups']->appendChild($this->document->importNode($modalNode, true));
    }

    /** Add <title> in to DOM */
    public function setTitlePage($title)
    {
        $titleNode = $this->document->createElement('title', $title);
        $this->defaultDom['head']->insertBefore($titleNode, $this->defaultDom['head']->childNodes->item(0));
    }

    /** Add <meta name="description/keywords"> in to DOM  */
    public function setMeta($meta)
    {
        $metaDescription = $this->document->createElement('meta');
        $metaDescription->setAttribute('name', 'description');

        if (isset($meta['description'])) {
            $metaDescription->setAttribute('content', $meta['description']);
        }

        $metaKeywords = $this->document->createElement('meta');
        $metaKeywords->setAttribute('name', 'keywords');

        if (isset($meta['keywords'])) {
            $metaKeywords->setAttribute('content', $meta['keywords']);
        }

        $this->defaultDom['head']->appendChild($metaDescription);
        $this->defaultDom['head']->appendChild($metaKeywords);
    }

    /** Find all images in DOM */
    private function findAllImages()
    {
        /** Extract all <image> elements */
        foreach ($this->document->getElementsByTagName('img') as $image) {
            /** Check file path is has remote url */
            if (strpos($image->getAttribute('src'), 'http') === false) {
                $this->imageFiles[] = $image->getAttribute('src');
                $image->setAttribute('data-src', 'bundles/' . pathinfo($image->getAttribute('src'), PATHINFO_BASENAME));
            } else {
                $image->setAttribute('data-src', $image->getAttribute('src'));
            }

            $image->setAttribute('src', 'data:image/gif;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+ip1sAAAAASUVORK5CYII=');
            $image->setAttribute('class', $image->getAttribute('class') . ' lazyload');
        }

        /** Extract parallax data-image-src files */
        foreach ($this->domXpath->query('//*[@data-parallax]') as $element) {
            $element->setAttribute('data-image-src', 'bundles/' . pathinfo($element->getAttribute('data-image-src'), PATHINFO_BASENAME));
            $this->imageFiles[] = 'bundles/' . pathinfo($element->getAttribute('data-image-src'), PATHINFO_BASENAME);
        }

        /** Extract images for lightbox plugin */
        foreach ($this->domXpath->query('//a[@data-toggle="lightbox"]') as $element) {
            $element->setAttribute('href', 'bundles/' . pathinfo($element->getAttribute('href'), PATHINFO_BASENAME));
            $this->imageFiles[] = 'bundles/' . pathinfo($element->getAttribute('href'), PATHINFO_BASENAME);
        }

        /** Extract images in the style attribute */
        foreach ($this->domXpath->query('//*[@style]') as $style) {
            $re = '/url\(\s*[\'"]?(\S*\.(?:jpe?g|gif|png))[\'"]?\s*\)[^;}]*?/i';
            if (preg_match_all($re, $style->getAttribute('style'), $matches)) {

                /** Check file path is has remote url */
                foreach ($matches[1] as $imgPath) {
                    if (strpos($imgPath, '//') === false) {
                        $this->imageFiles[] = $imgPath;
                        $style->setAttribute('style', str_replace($imgPath, 'bundles/' . pathinfo($imgPath, PATHINFO_BASENAME), $style->getAttribute('style')));
                    }
                }
            }
        }

        /** Extract images from a css files */
        foreach ($this->cssFiles as $cssLink) {
            /** extract CSS link, no need for blob uhrls */
            if (substr($cssLink, 0, 4) != 'blob') {

                /** extract images from CSS */
                if (substr($cssLink, 0, 4) != 'http' && substr($cssLink, 0, 2) != '//') {
                    $CSS = file_get_contents(Zend_Registry::get('config')->path->absolute->root . $cssLink);

                    $re = '/url\(\s*[\'"]?(\S*\.(?:jpe?g|gif|png))[\'"]?\s*\)[^;}]*?/i';
                    if (preg_match_all($re, $CSS, $matches)) {
                        foreach ($matches[1] as $imgPath) {
                            $this->imageFiles[] = Zend_Registry::get('config')->path->html->pagebuilder . 'elements/' . str_replace('../', '', $imgPath);
                        }
                    }
                }
            }
        }

        return $this;
    }

    /** Find all fonts in css files */
    private function findFonts()
    {
        /** Extract images from a css files */
        foreach ($this->cssFiles as $cssLink) {
            /** extract CSS link, no need for blob uhrls */
            if (substr($cssLink, 0, 4) != 'blob') {

                /** extract images from CSS */
                if (substr($cssLink, 0, 4) != 'http' && substr($cssLink, 0, 2) != '//') {
                    $CSS = file_get_contents(Zend_Registry::get('config')->path->absolute->root . $cssLink);

                    /** extract fonts from CSS */
                    $re = '/(?<=url\()[\'"]?(?!=http|https)(.*?\.(woff2|eot|woff|ttf|svg)).*?[\'"]?(?=\))/i';
                    if (preg_match_all($re, $CSS, $matches)) {
                        foreach ($matches[1] as $font) {
                            $info = new SplFileInfo(Zend_Registry::get('config')->path->absolute->root . pathinfo($cssLink, PATHINFO_DIRNAME) . DIRECTORY_SEPARATOR . $font);
                            if ($info->getRealPath() != false) {
                                $this->fontFiles[] = Zend_Registry::get('config')->path->html->pagebuilder . 'elements/' . str_replace('../', '', $font);
                            }
                        }
                    }
                }
            }
        }

        return $this;
    }

    /** Add all css and js code to generated page */
    private function addJsCssToPage()
    {
        if (!empty($this->styles)) {
            $inlineStyles = join('', $this->styles);
            $inlineStyles = str_replace('../', '', $inlineStyles);
            $styleNode    = $this->document->createElement('style', $inlineStyles);
            $this->defaultDom['head']->appendChild($styleNode);
        }

        if (!empty($this->addCss)) {
            $this->cssFiles = array_unique(array_merge($this->cssFiles, $this->addCss));
        }

        if (!empty($this->cssFiles)) {
            foreach ($this->cssFiles as $cssLink) {
                $linkNode = $this->document->createElement('link');
                $linkNode->setAttribute('rel', 'stylesheet');
                $linkNode->setAttribute('href', $cssLink);

                if (strpos($cssLink, 'http') === false) {
                    $linkNode->setAttribute('rel', 'stylesheet');
                    $linkNode->setAttribute('href', 'bundles/' . pathinfo($cssLink, PATHINFO_BASENAME));
                } else {
                    $linkNode->setAttribute('rel', 'stylesheet');
                    $linkNode->setAttribute('href', $cssLink);
                }

                $this->defaultDom['head']->appendChild($linkNode);
            }
        }

        if (!empty($this->addJs)) {
            $this->jsFiles = array_unique(array_merge($this->jsFiles, $this->addJs));
        }

        if (!empty($this->addScript)) {
            $this->scripts[] = $this->addScript;
        }

        if (!empty($this->scripts)) {
            $scriptNode = $this->document->createElement('script', join('', $this->scripts));
            $this->defaultDom['head']->appendChild($scriptNode);
        }

        if (!empty($this->jsFiles)) {
            /** Remove needless js files */
            $this->jsFiles = array_diff(
                $this->jsFiles,
                [
                    '/skin/pagebuilder/elements/bundles/Enterprise_gallery.bundle.js',
                    '/skin/pagebuilder/elements/bundles/Enterprise_headers.bundle.js',
                    '/skin/pagebuilder/elements/bundles/Enterprise_contact.bundle.js',
                    '/skin/pagebuilder/elements/bundles/Enterprise_footers.bundle.js',
                ]
            );

            foreach ($this->jsFiles as $jsLink) {
                $scriptNode = $this->document->createElement('script');
                $scriptNode->setAttribute('type', 'text/javascript');
                if (strpos($jsLink, 'http') === false && strpos($jsLink, '//') === false) {
                    $scriptNode->setAttribute('src', 'bundles/' . pathinfo($jsLink, PATHINFO_BASENAME));
                } else {
                    $scriptNode->setAttribute('src', $jsLink);
                }
                $scriptNode->setAttribute('defer', true);

                $this->defaultDom['body']->appendChild($scriptNode);
            }
        }

        return $this;
    }

    /** Add animate effect for blocks */
    private function parsingEffectBlocks($domDocument)
    {
        $domXpath = new DOMXpath($domDocument);

        /** Find all elements with have a attr data-effects */
        foreach ($domXpath->query('//*[@data-effects]') as $element) {
            $effectType = $element->getAttribute('data-effects');

            if ($effectType !== 'none') {
                $effectDelay = (int) $element->getAttribute('data-delayef');
                $effectId    = $element->getAttribute('data-id');

                $classList = $element->getAttribute('class');

                if (strpos($classList, 'hide') === false) {
                    $element->setAttribute('class', $classList . ' hide');
                }
            }
        }
    }

    /** Parsing component HTML/JS CODE */
    private function parsingCodeBlock($domDocument)
    {
        $domXpath = new DOMXpath($domDocument);
        $chunk    = new DOMDocument;

        $codeElements = $domXpath->query('//*[@class="code"]');
        while ($codeElements->length > 0) {
            $element = $codeElements->item(0);
            $option  = $element->getAttribute('data-option');

            /** Decode string */
            $option    = base64_decode($option);
            $option    = sprintf('<div>%s</div>', $option);
            $container = $domDocument->createElement('div');

            if ($option !== false && $chunk->loadHTML($option, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD)) {

                /** Moving elements in new a container element */
                foreach ($chunk->childNodes as $node) {
                    $container->appendChild($domDocument->importNode($node, true));
                }
            }

            /** Replace element with a class .codeblock on parsed HTML */
            $element->parentNode->parentNode->replaceChild($container, $element->parentNode);
            $codeElements = $domXpath->query('//*[@class="code"]');
        }

    }

    /** Add custom CSS/JS user code */
    public function addCustomUserCssJs()
    {
        $dom = new DOMDocument;

        /** Add [pages_header_includes] to a <head> */
        if (!empty($this->customUserJsCss['pages_header_includes']) && $dom->loadHTML($this->customUserJsCss['pages_header_includes'], LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD)) {
            $includes = $dom->childNodes;
            foreach ($includes as $node) {
                $this->defaultDom['head']->appendChild($this->document->importNode($node, true));
            }
        }

        /** Add [pages_css] to a <head> */
        if (!empty($this->customUserJsCss['pages_css'])) {
            $style = $this->document->createElement('style', $this->customUserJsCss['pages_css']);
            $this->defaultDom['head']->appendChild($style);
        }

        /** Add [global_css] to a <head> */
        if (!empty($this->customUserJsCss['global_css'])) {
            $style = $this->document->createElement('style', $this->customUserJsCss['global_css']);
            $this->defaultDom['head']->appendChild($style);
        }

        /** Add [header_script] to a <head> */
        if (!empty($this->customUserJsCss['header_script']) && $dom->loadHTML($this->customUserJsCss['header_script'], LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD)) {
            $includes = $dom->childNodes;

            foreach ($includes as $node) {
                $this->defaultDom['head']->appendChild($this->document->importNode($node, true));
            }
        }

        /** Add [footer_script] to a <body> */
        if (!empty($this->customUserJsCss['footer_script']) && $dom->loadHTML($this->customUserJsCss['footer_script'], LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD)) {
            $includes = $dom->childNodes;

            foreach ($includes as $node) {
                $this->defaultDom['body']->appendChild($this->document->importNode($node, true));
            }
        }

        /** Add [pages_header_script] to a <head> */
        if (!empty($this->customUserJsCss['pages_header_script']) && $dom->loadHTML($this->customUserJsCss['pages_header_script'], LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD)) {
            $includes = $dom->childNodes;

            foreach ($includes as $node) {
                $this->defaultDom['head']->appendChild($this->document->importNode($node, true));
            }
        }

        /** Add [pages_footer_script] to a <body> */
        if (!empty($this->customUserJsCss['pages_footer_script']) && $dom->loadHTML(sprintf("<div>%s</div>", $this->customUserJsCss['pages_footer_script']), LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD)) {
            $includes = $dom->childNodes->item(0)->childNodes;

            foreach ($includes as $node) {
                $this->defaultDom['body']->appendChild($this->document->importNode($node, true));
            }
        }
    }

    /** Return HTML code of generated page */
    public function returnHTML(&$buffer, &$files)
    {
        if ($this->domXpath->query('//div[@data-component="video2"]')->length) {
            $this->jsFiles[] = '/skin/ifunnels-studio/dist/js/video2.bundle.js';
        }

        $this
            ->findAllImages()
            ->findFonts()
            ->addJsCssToPage()
            ->addCustomUserCssJs();

        $scripts = $this->document->getElementsByTagName('script');

        foreach ($scripts as $script) {
            if (in_array($script->getAttribute('src'), ['/skin/ifunnels-studio/dist/js/webinar.bundle.js'])) {
                $script->setAttribute('src', '');
            }
        }

        $files['css']   = array_unique($this->cssFiles);
        $files['js']    = array_unique($this->jsFiles);
        $files['font']  = array_unique($this->fontFiles);
        $files['image'] = array_unique($this->imageFiles);
        $files['json']  = $this->jsonFiles;

        /**
         * Rewardful script
         */
        Project_Deliver::getRewardfulAPIKey($rewardful_ak);

        if ($rewardful_ak) {

            $scriptNode = $this->document->createElement('script', "(function(w,r){w._rwq=r;w[r]=w[r]||function(){(w[r].q=w[r].q||[]).push(arguments)}})(window,'rewardful');");
            $scriptNode->setAttribute('type', 'text/javascript');

            $this->defaultDom['head']->appendChild($scriptNode);

            $scriptLink = $this->document->createElement('script');
            $scriptLink->setAttribute('src', 'https://r.wdfl.co/rw.js');
            $scriptLink->setAttribute('data-rewardful', $rewardful_ak);
            $scriptLink->setAttribute('async');

            $this->defaultDom['head']->appendChild($scriptLink);
        }

        /** END Rewardful script */

        $buffer = $this->document->saveHTML();

        $this->reset();
    }

    /** Reset all field to base state */
    private function reset()
    {
        $this->addCss          = array();
        $this->addJs           = array();
        $this->addScript       = '';
        $this->customUserJsCss = array();

        $this->styles   = array();
        $this->scripts  = array();
        $this->cssFiles = array();
        $this->jsFiles  = array();

        $this->imageFiles = array();
        $this->fontFiles  = array();

        $this->init();
    }

    /** Insert HTML for login form if page protected */
    public function setProtected($membershipIds = [], $primary_membership = null)
    {
        $protectedHTML = file_get_contents(Zend_registry::get('config')->path->absolute->pagebuilder . 'templates' . DIRECTORY_SEPARATOR . 'signin.html');

        $dom = new DOMDocument;
        $dom->loadHTML($protectedHTML, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);

        foreach ($dom->childNodes as $node) {
            $this->defaultDom['body']->appendChild($this->document->importNode($node, true));
        }

        $this->cssFiles[] = 'https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/components/icon.min.css';
        $this->cssFiles[] = Zend_Registry::get('config')->path->html->root . 'skin/ifunnels-studio/dist/css/protect.bundle.css';

        $this->jsFiles[] = Zend_Registry::get('config')->path->html->root . 'skin/ifunnels-studio/dist/js/protect.bundle.js';

        $this->imageFiles[] = Zend_Registry::get('config')->path->html->root . 'skin/ifunnels-studio/dist/img/graphic2.svg';
        $this->imageFiles[] = Zend_Registry::get('config')->path->html->root . 'skin/ifunnels-studio/dist/img/graphic7.svg';
        $this->imageFiles[] = Zend_Registry::get('config')->path->html->root . 'skin/ifunnels-studio/dist/img/register-bg.png';

        $membership = new Project_Deliver_Membership();
        $membership
            ->withIds($primary_membership)
            ->onlyOne()
            ->getList($membershipData);

        $site = new Project_Deliver_Site();
        $site
            ->withIds($membershipData['site_id'])
            ->onlyOne()
            ->getList($siteData);

        $site_url = (!empty($_SERVER['HTTPS']) && 'off' !== strtolower($_SERVER['HTTPS']) ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'];

        $primary_membership = [
            'id'                => $membershipData['id'],
            'require_shipping'  => ($membershipData['require_shipping'] === '0' ? false : true),
            'free'              => ($membershipData['type'] === '0' ? true : false),
            'frequency'         => intval($membershipData['frequency']),
            'title'             => $membershipData['name'],
            'currency'          => $siteData['currency'],
            'amount'            => floatval($membershipData['amount']),
            'logo'              => $siteData['logo'],
            'total_amount'      => floatval($membershipData['amount']),
            'billing_frequency' => $membershipData['billing_frequency'],
            'limit_rebills'     => intval($membershipData['limit_rebills']),
            'home_page_url'     => $membershipData['home_page_url'],
            'label_charges'     => $membershipData['label_charges'],
        ];

        if ($primary_membership['require_shipping']) {
            $insCountry = new Project_Deliver_Country();

            if (!in_array('ALL', $membershipData['allowed_contries'])) {
                $insCountry
                    ->withIsoCodes($membershipData['allowed_contries']);
            }

            $insCountry
                ->withOrder('name--dn')
                ->getList($primary_membership['allowed_contries']);
        }

        /** Trial */
        if ((!empty($membershipData['trial_amount']) || $membershipData['trial_amount'] === '0') && !empty($membershipData['trial_duration'])) {
            $primary_membership['trial']          = true;
            $primary_membership['trial_amount']   = floatval($membershipData['trial_amount']);
            $primary_membership['trial_duration'] = floatval($membershipData['trial_duration']);
        } else {
            $primary_membership['trial'] = false;
        }

        /** Additional Charges */
        if (!empty($membershipData['add_charges'])) {
            $primary_membership['add_charges']           = floatval($membershipData['add_charges']);
            $primary_membership['add_charges_frequency'] = $membershipData['add_charges_frequency'];
            $primary_membership['total_amount'] += floatval($membershipData['add_charges']);
        }

        /** Taxes */
        if (!empty($membershipData['add_taxes'])) {
            $primary_membership['add_taxes'] = floatval($membershipData['add_taxes']);
            $primary_membership['total_amount'] += ($primary_membership['total_amount'] * floatval($membershipData['add_taxes']) / 100);
        }

        if (!empty($primary_membership['logo'])) {
            $primary_membership['logo'] = $site_url . $primary_membership['logo'];
        }

        $stripe = [
            'publicKey'     => Project_Deliver_Stripe::getPublicKey(),
            'stripeAccount' => $membershipData['stripe_account'],
        ];

        /** Added membership ids */
        $this->addScript = 'var config = ' . json_encode(
            [
                'memberships'        => $membershipIds,
                'primary_membership' => $primary_membership,
                'stripe'             => $stripe,
                'request_url'        => $site_url . '/services/deliver-request.php',
                'auth_url'           => $site_url . '/services/deliver-signin.php',
                'forgot_url'         => $site_url . Core_Module_Router::getInstance()->generateFrontendUrl(['name' => 'site1_deliver', 'action' => 'forgot_password', 'w' => ['token' => base64_encode(serialize(['membership' => $membershipData['id']]))]]),
            ]
        ) . ';';
    }

    /**
     * Clear cache on CloudFlare for selected domain
     *
     * @static
     * @param [string] $domain_name
     * @return boolean
     */
    public static function clearCache($domain_name)
    {
        $curl = curl_init();

        curl_setopt_array($curl, [
            CURLOPT_URL            => 'https://api.cloudflare.com/client/v4/zones?' . http_build_query(['name' => $domain_name]),
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER     => [
                'X-Auth-Email: anna.fiadorchanka@gmail.com',
                'X-Auth-Key: 44f696fb9760dbd564d24720e74bdad4a74ec',
                'Content-Type: application/json',
            ],
        ]);

        $data = curl_exec($curl);

        if ($data === false) {
            return Core_Data_Errors::getInstance()->setError('CURL Error: ' . curl_error($curl));
        }

        $data = json_decode($data, true);

        if (empty($data['result'])) {
            return false;
        }

        $domain_id = $data['result'][0]['id'];

        if (empty($domain_id)) {
            return false;
        }

        $curl = curl_init();
        curl_setopt_array($curl, array(
            CURLOPT_URL            => 'https://api.cloudflare.com/client/v4/zones/' . $domain_id . '/purge_cache',
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER     => array(
                'X-Auth-Email: anna.fiadorchanka@gmail.com',
                'X-Auth-Key: 44f696fb9760dbd564d24720e74bdad4a74ec',
                'Content-Type: application/json',
            ),
            CURLOPT_POST           => 1,
            CURLOPT_SSL_VERIFYPEER => 0,
            CURLOPT_POSTFIELDS     => json_encode(["purge_everything" => true]),
        ));

        $data = curl_exec($curl);

        if ($data === false) {
            return Core_Data_Errors::getInstance()->setError('CURL Error: ' . curl_error($curl));
        }

        return true;
    }
}
