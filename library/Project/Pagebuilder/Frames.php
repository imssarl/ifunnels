<?php

require_once Zend_Registry::get('config')->path->relative->library . 'SimpleHTMLDom/simple_html_dom.php';

class Project_Pagebuilder_Frames extends Core_Data_Storage
{
    protected $_table  = 'pb_frames';
    protected $_fields = array('id', 'pages_id', 'sites_id', 'position', 'frames_content', 'frames_height', 'frames_original_url', 'frames_loaderfunction', 'frames_sandbox', 'frames_timestamp', 'frames_global', 'frames_popup', 'frames_embeds', 'frames_settings', 'favourite', 'revision', 'created_at', 'modified_at');

    protected $_withPageId          = false;
    protected $_withSiteId          = false;
    protected $_withRevision        = false;
    protected $_withFramesTimestamp = false;
    protected $_withoutDecode       = false;

    public function withPageId($_pageid)
    {
        $this->_withPageId = $_pageid;
        return $this;
    }

    public function withSiteId($_siteid)
    {
        $this->_withSiteId = $_siteid;
        return $this;
    }

    public function withRevision($_state)
    {
        $this->_withRevision = $_state;
        return $this;
    }

    public function withFramesTimestamp($timestamp)
    {
        $this->_withFramesTimestamp = $timestamp;
        return $this;
    }

    public function withoutDecode()
    {
        $this->_withoutDecode = true;
        return $this;
    }

    public function beforeSet()
    {
        $this->_data->setFilter(array('clear'));
        if (isset($this->_data->filtered['frames_content']) && !$this->_withoutDecode) {
            $this->_data->filtered['frames_content'] = self::processFrameContent(base64_decode($this->_data->filtered['frames_content']));
        }

        return true;
    }

    public function set()
    {
        $this->_data->setFilter(array('clear'));
        if (!$this->beforeSet()) {
            return false;
        }

        $this->_data->setElement('id', Core_Sql::setInsertUpdate($this->_table, $this->_data->filtered));
        return $this->afterSet();
    }

    public function afterSet()
    {
        $this->_withoutDecode = false;
        return $this;
    }

    protected function assemblyQuery()
    {
        parent::assemblyQuery();
        if ($this->_withPageId) {
            $this->_crawler->set_where('d.pages_id IN (' . Core_Sql::fixInjection($this->_withPageId) . ')');
        }
        if ($this->_withSiteId) {
            $this->_crawler->set_where('d.sites_id = ' . Core_Sql::fixInjection($this->_withSiteId));
        }
        if ($this->_withRevision !== false) {
            $this->_crawler->set_where('d.revision = ' . Core_Sql::fixInjection($this->_withRevision));
        }
        if ($this->_withFramesTimestamp !== false) {
            $this->_crawler->set_where('d.frames_timestamp = ' . Core_Sql::fixInjection($this->_withFramesTimestamp));
        }
    }

    public static function processFrameContent($frameContent)
    {
        $dom = new DOMDocument;
        $dom->loadHTML($frameContent, LIBXML_HTML_NODEFDTD);

        $domXpath = new DOMXpath($dom);

        /** remove data-selector attributes */
        foreach ($domXpath->query('//*[@data-selector]') as $element) {
            /** remove attribute */
            $element->removeAttribute("data-selector");
        }

        /** remove data-sbpro-editor attributes */
        foreach ($domXpath->query('//*[@data-sbpro-editor]') as $element) {
            /** remove attribute */
            $element->removeAttribute("data-sbpro-editor");
        }

        /** remove draggable attributes */
        foreach ($domXpath->query('//*[@draggable]') as $element) {
            $element->removeAttribute("draggable");
        }

        /** remove builder scripts (these are injected when loading the iframes) */
        foreach ($domXpath->query('//script[contains(@class, "builder")]') as $element) {
            $element->parentNode->removeChild($element);
        }

        /** remove background images for parallax blocks */
        foreach ($domXpath->query('//*[@data-parallax]') as $element) {
            $oldCss      = $element->getAttribute('style');
            $replaceWith = "background-image: none";
            $regex       = '/(background-image: url\((["|\']?))(.+)(["|\']?\))/';
            $oldCss      = preg_replace($regex, $replaceWith, $oldCss);
            $element->setAttribute('style', $oldCss);
        }

        /** remove data-hover="true" attribute **/
        foreach ($domXpath->query('//*[@data-hover]') as $element) {
            $element->removeAttribute("data-hover");
        }

        /** remove the sb_hover class name **/
        foreach ($domXpath->query('//*[contains(@class, "sb_hover")]') as $element) {
            $element->setAttribute('class', str_replace('sb_hover', '', $element->getAttribute('class')));
        }

        /** remove .canvasElToolbar elements **/
        foreach ($domXpath->query('//div[contains(@class, "canvasElToolbar")]') as $element) {
            $element->parentNode->removeChild($element);
        }

        /** remove .canvasQuizToolbar elements **/
        foreach ($domXpath->query('//div[contains(@class, "canvasQuizToolbar")]') as $element) {
            $element->parentNode->removeChild($element);
        }

        foreach ($domXpath->query("//*[@href]") as $element) {
            $element->setAttribute('href', str_replace('..', '/skin/pagebuilder/elements', $element->getAttribute('href')));
        }

        foreach ($domXpath->query("//*[@src]") as $element) {
            $element->setAttribute('src', str_replace('..', '/skin/pagebuilder/elements', $element->getAttribute('src')));
        }

        foreach ($domXpath->query("//*[@style]") as $element) {
            $element->setAttribute('style', str_replace('..', '/skin/pagebuilder/elements', $element->getAttribute('style')));
        }

        return $dom->saveHTML();
    }

    protected function init()
    {
        parent::init();
        $this->_withPageId          = false;
        $this->_withSiteId          = false;
        $this->_withRevision        = false;
        $this->_withFramesTimestamp = false;
        $this->_withoutDecode       = false;
    }
}
