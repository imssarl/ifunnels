/** global var isSigned, lockscreen  */

import axios from 'axios';
import Cookies from 'js-cookie';

const cookieKey = 'loginName';

export default class Lockscreen {
    constructor () {
        this.delay = 5000;
        const {requestUrl, authUrl, isBackend} = lockscreen;

        this.requestUrl = requestUrl;
        this.authUrl = authUrl;
        this.enableRecursive = true;
        this.inputKeys = {
            username : ! isBackend ? 'username' : 'email',
            passwd : 'passwd'
        }

        this.modalDOM = document.querySelector('.lockscreen');
        if( ! isBackend ) {
            this.username = Cookies.get(cookieKey);
        } else {
            this.username = isBackend;
        }

        this.usernameDOMElement = document.querySelector('.lockscreen__container__username');
        this.usernameSingInDOMElement = this.modalDOM.querySelector('.lockscreen__signin');
        this.usernameDOMInput = this.modalDOM.querySelector(`[name="arrLogin[${this.inputKeys.username}]"]`);
        this.passwordDOMInput = this.modalDOM.querySelector(`[name="arrLogin[${this.inputKeys.passwd}]"]`);

        this.init();
    }

    init() {
        this.outputUserName();
        this.recursiveQuery();
        this.bindActions();
    }

    /** Adding event listeners for elements of the form */
    bindActions() {
        this.modalDOM.querySelector('form').addEventListener('submit', (e) => {
            e.preventDefault();

            const data = new FormData();
            data.append(`arrLogin[${this.inputKeys.username}]`, this.usernameDOMInput.value);
            data.append(`arrLogin[${this.inputKeys.passwd}]`, this.passwordDOMInput.value);

            axios({
                method: 'post',
                url: this.authUrl,
                data,
                headers: {'Content-Type': 'multipart/form-data' }
            }).then((response) => {
                if( response.status === 200 ) {
                    if( response.data.authorized ) {
                        this.hideModal();
                        this.resetForm();
                        this.recursiveQuery();
                        isSigned = true;
                    } else {
                        this.passwordDOMInput.classList.add('error-field');
                    }
                }
            });

        });
    }

    /** Reset values in form field */
    resetForm() {
        this.usernameDOMInput.value = this.username;
        this.passwordDOMInput.value = '';

        this.passwordDOMInput.classList.remove('error-field');
    }

    /** Output username in Lockscreen Modal */
    outputUserName() {
        if( ! this.usernameDOMElement ) {
            return;
        }

        this.usernameDOMElement.innerHTML = `${this.username || 'Unknown User'}`;
        this.usernameDOMInput.value = this.username;
        this.usernameSingInDOMElement.children[0].innerHTML = this.username;
    }

    /** Init setInterval */
    recursiveQuery() {
        this.handlerInterval = setInterval( () => {
            this.sendRequest();
        }, this.delay );
    }

    /** Sending request on server and getting json data about authorize user */
    sendRequest() {
        axios.get(this.requestUrl).then(({data}) => {
            if( data.hasOwnProperty('authorized') ) {
                if( data.authorized === false ) {
                    this.enableRecursive = false;
                    clearInterval( this.handlerInterval );
                    isSigned = false;
                    this.showModal();
                }
            }
        });
    }

    /** Show Modal */
    showModal() {
        this.modalDOM.style.display = 'flex';
        document.body.classList.add('overflow-hidden');
    }

    /** Hide Modal */
    hideModal() {
        this.modalDOM.style.display = 'none';
        document.body.classList.remove('overflow-hidden');
    }

}