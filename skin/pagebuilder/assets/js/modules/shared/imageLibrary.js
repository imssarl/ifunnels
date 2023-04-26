(function (){
	"use strict";

    let bConfig = require('../config.js');
    let editor = require('../builder/styleeditor.js').styleeditor;
    let appUI = require('./ui.js').appUI;
    let publisher = require('../../vendor/publisher');

    let imageLibrary = {

        imageModal: document.getElementById('imageModal'),
        myImages: document.getElementById('myImages'),//used in the image library, outside the builder UI
        selectedImage: "",//
        buttonImageModalUseImage: document.getElementById('buttonImageModalUseImage'),

        divImageLibrary: document.getElementById('divImageLibrary'),

        inputSlimUpload: document.getElementById('slimUpload'),

        divImageDetailPanel: document.getElementById('imageDetailPanel'),
        imgSlimEditImage: document.getElementById('slimEditImage'),
        slimWithSettings: document.getElementById('slimWithSettings'),

        linkFullImage: document.getElementById('linkFullImage'),
        inputImageWidth: document.getElementById('inputImageWidth'),
        inputImageHeight: document.getElementById('inputImageHeight'),
        checkFixedRatio: document.getElementById('checkFixedRation'),
        buttonUpdateImageDimensions: document.getElementById('buttonUpdateImageDimensions'),

        buttonDeleteImage: document.getElementById('buttonDeleteImage'),
        confirmDeleteImage: document.getElementById('confirmDeleteImage'),
        imageDeleteYes: document.getElementById('imageDeleteYes'),
        imageDeleteNo: document.getElementById('imageDeleteNo'),

        formStyleEditor: document.getElementById('stylingForm'),

        anchorMyImagesTab: document.getElementById('anchorMyImagesTab'),

        init: function(){
            if(showModal) return;

            $('a#ie_admintab, a#ie_myimagestab').on('show.bs.tab', function (e) {
                var href = $(e.target).attr('href');
                $(href).find('img').trigger('sporty');
            });

            $(this.buttonImageModalUseImage).on('click', imageLibrary.useSelectedImage);

            window['slimImageUpload'] = this.slimImageUpload;
            window['slimImageUpdate'] = this.slimImageUpdate;
            window['slimImageTransform'] = this.slimImageTransform;
            window['slimHandleServerError'] = this.slimHandleServerError;

            if ( imageLibrary.inputImageWidth !== null ) {
                imageLibrary.inputImageWidth.addEventListener('blur', this.enforeImageRatio);
                imageLibrary.inputImageWidth.addEventListener('change', this.enforeImageRatio);
                imageLibrary.inputImageWidth.addEventListener('keyup', this.enforeImageRatio);
            }

            if ( imageLibrary.inputImageHeight !== null ) {
                imageLibrary.inputImageHeight.addEventListener('blur', this.enforeImageRatio);
                imageLibrary.inputImageHeight.addEventListener('change', this.enforeImageRatio);
                imageLibrary.inputImageHeight.addEventListener('keyup', this.enforeImageRatio);
            }

            if ( imageLibrary.buttonUpdateImageDimensions !== null ) {
                imageLibrary.buttonUpdateImageDimensions.addEventListener('click', this.updateDimensions);
            }

            if( this.buttonDeleteImage ) {
                this.buttonDeleteImage.addEventListener('click', function (e) {

                    e.preventDefault();
    
                    $(e.target).fadeOut( () => { $(imageLibrary.confirmDeleteImage).fadeIn();});
    
                });
            }
            

            if( this.imageDeleteNo ) {
                this.imageDeleteNo.addEventListener('click', function (e) {

                    e.preventDefault();
    
                    $(imageLibrary.confirmDeleteImage).fadeOut( () => { $(imageLibrary.buttonDeleteImage).fadeIn();});
    
                });
            }
            
            if( this.imageDeleteYes ) {
                this.imageDeleteYes.addEventListener('click', function (e) {

                    e.preventDefault();
                    
                    var data = {
                        image: imageLibrary.selectedImage.getAttribute('data-org-src'),
                        thumb: imageLibrary.selectedImage.getAttribute('data-thumb')
                    }
    
                    $.ajax({
                        url: appUI.dataUrls.delimage,
                        data: data,
                        type: 'post'
                    }).done(function(){
    
                        //reset panel
                        imageLibrary.resetImageEditPanel();
    
                        //hide panel
                        imageLibrary.divImageDetailPanel.classList.remove('open');
    
                        //delete the image
                        $(imageLibrary.selectedImage).closest('.image').fadeOut( function () {
                            this.remove();
                        });
    
    
                    });
    
                });
            }
            

            $(this.imageModal).on('show.bs.modal', function () {

                imageLibrary.divImageDetailPanel.classList.remove('open');
                imageLibrary.resetImageEditPanel();
                
                //load images
                var images = imageLibrary.divImageLibrary.querySelectorAll('img[data-original-src]'),
                    image,
                    imageUrl;

                for ( image in images ) {
                    if ( images.hasOwnProperty(image) ) {
                        images[image].setAttribute('src', images[image].getAttribute('data-original-src'));
                        images[image].removeAttribute('data-original-src');
                    }
                }

                if ( Object.keys(editor.activeElement).length > 0 ) {

                    //make sure we exclude the string parameters
                    if ( editor.activeElement.element.getAttribute('src') !== null ) {
                        imageUrl = editor.activeElement.element.getAttribute('src').replace(/^.*[\\\/]/, '').split('?')[0];
                    }

                    //activate an image in the modal?
                    $('#imageModal .image .imageWrap').each(function () {

                        if ( this.hasAttribute('data-org-src') && this.getAttribute('data-org-src').replace(/^.*[\\\/]/, '') === imageUrl ) {
                            $(".nav-tabs a[href='#myImagesTab']", imageLibrary.imageModal).tab('show');
                            imageLibrary.imageInLibraryClickOn(this);
                        } else {
                            $(this).closest('.image').removeClass('active');
                        }

                    });

                }

            });

            $(imageLibrary.divImageLibrary).on('click', '.image', imageLibrary.imageInLibraryClick);

        },

        /*
            Reset image edit panel
        */
        resetImageEditPanel: function () {

            imageLibrary.confirmDeleteImage.style.display = 'none';
            imageLibrary.buttonDeleteImage.style.display = 'inline';

            if ( imageLibrary.buttonImageModalUseImage ) imageLibrary.buttonImageModalUseImage.disabled = true;

        },


        /*
            Updates the dimensions of the selected image on the server
        */
        updateDimensions: function () {

            var buttonText = imageLibrary.buttonUpdateImageDimensions.innerText;

            imageLibrary.buttonUpdateImageDimensions.innerText = imageLibrary.buttonUpdateImageDimensions.getAttribute('data-loading');
            imageLibrary.buttonUpdateImageDimensions.setAttribute('disabled', true);
            
            $.ajax({
                url: appUI.dataUrls.resizeImage,
                data: {image: imageLibrary.selectedImage.getAttribute('data-org-src'), width: imageLibrary.inputImageWidth.value, height: imageLibrary.inputImageHeight.value },
                type: 'post',
                dataType: 'json'
            }).done(function (res) {

                imageLibrary.buttonUpdateImageDimensions.innerText = imageLibrary.buttonUpdateImageDimensions.getAttribute('data-confirm');
                imageLibrary.buttonUpdateImageDimensions.removeAttribute('disabled');

                setTimeout(function () {
                    imageLibrary.buttonUpdateImageDimensions.innerText = buttonText;
                }, 4000);

                if ( res.responseCode === 1 ) {

                    //reload the thumbnail
                    /*var oldSrc = imageLibrary.selectedImage.getAttribute('data-thumb');
                    imageLibrary.selectedImage.setAttribute('src', oldSrc + "?" + Math.random());

                    imageLibrary.selectedImage.style.backgroundImage = "url('" + oldSrc + "?" + Math.random() + "')";*/

                    //reload the Slim cropper
                    imageLibrary.currentSlimEdit.destroy();

                    imageLibrary.imgSlimEditImage.setAttribute('src', imageLibrary.selectedImage.getAttribute('data-org-src') + "?" + Math.random());

                    imageLibrary.currentSlimEdit = Slim.create(imageLibrary.imgSlimEditImage, {
                        ratio: imageLibrary.selectedImage.getAttribute('data-ratio'),
                        service: imageLibrary.selectedImage.getAttribute('data-service'),
                        fetcher: imageLibrary.selectedImage.getAttribute('data-fetcher'),
                        maxFileSize: imageLibrary.selectedImage.getAttribute('data-max-file-size'),
                        statusFileType: imageLibrary.selectedImage.getAttribute('data-status-file-type'),
                        statusImageTooSmall: imageLibrary.selectedImage.getAttribute('data-status-image-too-small'),
                        statusUnknownResponse: imageLibrary.selectedImage.getAttribute('data-status-unknown-response'),
                        statusUploadSuccess: imageLibrary.selectedImage.getAttribute('data-status-upload-success'),
                        didUpload: slimImageUpdate,
                        buttonCancelLabel: imageLibrary.selectedImage.getAttribute('data-button-cancel-label'),
                        buttonConfirmLabel: imageLibrary.selectedImage.getAttribute('data-button-confirm-label'),
                        label: imageLibrary.selectedImage.getAttribute('data-label'),
                        push: true
                    });
                    

                }

            });

        },


        /*
            Enforce the image dimension ratio
        */
        enforeImageRatio: function (e) {

            var input = e.target,
                ratio = imageLibrary.selectedImage.getAttribute('data-ratio');

            if ( imageLibrary.checkFixedRatio.checked ) {

                if ( input === imageLibrary.inputImageWidth ) {

                    //apply proper value to height
                    imageLibrary.inputImageHeight.value = Math.round(imageLibrary.inputImageWidth.value / ratio);


                } else if ( input === imageLibrary.inputImageHeight ) {

                    //apply proper value to height
                    imageLibrary.inputImageWidth.value = Math.round(imageLibrary.inputImageHeight.value * ratio);

                }

            }

        },

        /*
            Called when the "use image" button is clicked
        */
        useSelectedImage: function () {


            if (imageLibrary.selectedImage !== '' ) {

                if ( editor.activeElement.element.tagName === 'IMG' ) {//editing an image directly
                    
                    //update live image
                    if ( editor.activeElement.element.hasAttribute('src') ) $(editor.activeElement.element).attr('src', imageLibrary.selectedImage.getAttribute('data-org-src') + "?" + Math.random());

                    //if this is a lightbox image
                    if ( $(editor.activeElement.element).parents(bConfig.imageLightboxWrapper).size() > 0 ) {
                        $(editor.activeElement.element).parents(bConfig.imageLightboxWrapper).find('a').attr('href', imageLibrary.selectedImage.getAttribute('data-org-src'));
                    }

                    $(editor.activeElement.element).on('load', function () {
                        
                        editor.activeElement.parentBlock.heightAdjustment();

                    }.bind(this));

                } else {//editing background of HTML element

                    //update the INPUT value
                    imageLibrary.formStyleEditor.querySelector('input[name="background-image"]').value = 'url(' + imageLibrary.selectedImage.getAttribute('data-org-src') + ')';

                }

                //hide modal
                $('#imageModal').modal('hide');

                //height adjustment of the iframe heightAdjustment
                //editor.activeElement.parentBlock.heightAdjustment();

                //we've got pending changes
                publisher.publish('onPendingChanges');

            }

        },


        slimHandleServerError: function (error, defaultError) {

            return error;

        },


        /*
            call back fired after Slim sends image over to the server
        */
        slimImageUpload: function (error, data, response) {

            var divImage = document.createElement('DIV'),
                divImageWrap = document.createElement('DIV'),
                img = document.createElement('IMG');
            
            if ( response.status === 'success' ) {

                if ( response.usedspace && imageLibrary.anchorMyImagesTab ) {
                    imageLibrary.anchorMyImagesTab.querySelector('span').innerText = response.usedspace;
                }

                //reset the upload field
                $(imageLibrary.inputSlimUpload).parent().find('button.slim-btn-remove').trigger('click');

                //add uploaded image to gallery
                divImage.classList.add('image');
                divImageWrap.classList.add('imageWrap');

                divImageWrap.style.backgroundImage = "url('" + response.thumb + "')";
                divImageWrap.setAttribute('data-ratio', 'free');
                divImageWrap.setAttribute('data-service', imageLibrary.slimWithSettings.getAttribute('data-service'));
                divImageWrap.setAttribute('data-fetcher', imageLibrary.slimWithSettings.getAttribute('data-fetcher'));
                divImageWrap.setAttribute('data-max-file-size', imageLibrary.slimWithSettings.getAttribute('data-status-file-size'));
                divImageWrap.setAttribute('data-status-file-type', imageLibrary.slimWithSettings.getAttribute('data-status-file-type'));
                divImageWrap.setAttribute('data-status-image-too-small', imageLibrary.slimWithSettings.getAttribute('data-status-image-too-small'));
                divImageWrap.setAttribute('data-status-unknown-response', imageLibrary.slimWithSettings.getAttribute('data-status-unknown-response'));
                divImageWrap.setAttribute('data-status-upload-success', imageLibrary.slimWithSettings.getAttribute('data-status-upload-success'));
                divImageWrap.setAttribute('data-did-upload', 'slimImageUpdate');
                divImageWrap.setAttribute('data-button-cancel-label', imageLibrary.slimWithSettings.getAttribute('data-button-cancel-label'));
                divImageWrap.setAttribute('data-button-confirm-label', imageLibrary.slimWithSettings.getAttribute('data-button-confirm-label'));
                divImageWrap.setAttribute('data-label', imageLibrary.slimWithSettings.getAttribute('data-label'));
                divImageWrap.setAttribute('data-org-src', response.full);
                divImageWrap.setAttribute('data-thumb', response.thumb);

                divImage.appendChild(divImageWrap);

                imageLibrary.myImages.appendChild(divImage);

            }

        },


        /*
            call back fired after Slim uploads edited image to the server
        */
        slimImageUpdate: function (error, data, response) {

            //reload the thumbail of the selected image
            var oldSrc = imageLibrary.selectedImage.getAttribute('data-thumb');

            imageLibrary.selectedImage.style.backgroundImage = "url('" + oldSrc + "?" + Math.random() + "')";

        },

        slimImageTransform: function (data, ready) {

            //update the height/width
            imageLibrary.inputImageWidth.value = data.output.width;
            imageLibrary.inputImageHeight.value = data.output.height;

            ready(data);

        },

        /*
            Called when an image inside the image library is clicked
        */
        imageInLibraryClick: function () {

            if ( $(this).closest('.image')[0].classList.contains('active') ) {

                imageLibrary.imageInLibraryClickOff(this);

            } else {

                imageLibrary.imageInLibraryClickOn(this);

            }

        },

        /*
            Deselect selected image
        */
        imageInLibraryClickOff: function (img) {

            imageLibrary.selectedImage = "";
            $(img).closest('.image').removeClass('active');

            imageLibrary.divImageDetailPanel.classList.remove('open');

            if ( imageLibrary.buttonImageModalUseImage ) imageLibrary.buttonImageModalUseImage.disabled = true;

        },

        /*
            Select unselected image
        */
        imageInLibraryClickOn: function (img) {

            var image = document.createElement('IMG'),
                width,
                height;

            //reset edit image side panel
            imageLibrary.resetImageEditPanel();

            if ( imageLibrary.buttonImageModalUseImage ) imageLibrary.buttonImageModalUseImage.disabled = false;

            $('.image', imageLibrary.divImageLibrary).removeClass('active');

            imageLibrary.selectedImage = $(img).closest('.image').find('.imageWrap')[0];
            $(img).closest('.image').addClass('active');

            //editing only allowed for user images
            if ( !imageLibrary.selectedImage.getAttribute('data-admin') ) {

                //show a link
                imageLibrary.linkFullImage.innerText = imageLibrary.selectedImage.getAttribute('data-org-src').replace(/^.*[\\\/]/, '');
                imageLibrary.linkFullImage.href = imageLibrary.selectedImage.getAttribute('data-org-src');

                //destroy Slim cropper first
                Slim.destroy(imageLibrary.imgSlimEditImage);

                imageLibrary.imgSlimEditImage.setAttribute('src', imageLibrary.selectedImage.getAttribute('data-org-src'));

                imageLibrary.currentSlimEdit = Slim.create(imageLibrary.imgSlimEditImage, {
                    ratio: imageLibrary.selectedImage.getAttribute('data-ratio'),
                    service: imageLibrary.selectedImage.getAttribute('data-service'),
                    fetcher: imageLibrary.selectedImage.getAttribute('data-fetcher'),
                    maxFileSize: imageLibrary.selectedImage.getAttribute('data-max-file-size'),
                    statusFileType: imageLibrary.selectedImage.getAttribute('data-status-file-type'),
                    statusImageTooSmall: imageLibrary.selectedImage.getAttribute('data-status-image-too-small'),
                    statusUnknownResponse: imageLibrary.selectedImage.getAttribute('data-status-unknown-response'),
                    statusUploadSuccess: imageLibrary.selectedImage.getAttribute('data-status-upload-success'),
                    didUpload: slimImageUpdate,
                    didReceiveServerError: slimHandleServerError,
                    willTransform: slimImageTransform,
                    buttonCancelLabel: imageLibrary.selectedImage.getAttribute('data-button-cancel-label'),
                    buttonConfirmLabel: imageLibrary.selectedImage.getAttribute('data-button-confirm-label'),
                    label: imageLibrary.selectedImage.getAttribute('data-label'),
                    push: true
                });

                //retrieve the image's dimensions
                image.src = imageLibrary.selectedImage.getAttribute('data-org-src');
                image.style.position = "absolute";
                image.style.left = "-10000px";
                image.style.top = "0px";

                document.body.appendChild(image);

                image.addEventListener('load', function () {
                    imageLibrary.inputImageWidth.value = image.width;
                    imageLibrary.inputImageHeight.value = image.height;
                    imageLibrary.selectedImage.setAttribute('data-ratio', image.width / image.height);
                    image.remove();
                });

                imageLibrary.divImageDetailPanel.classList.add('open');

            }

        }


    };

    imageLibrary.init();

}());