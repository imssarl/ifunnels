import '../scss/style.scss';
import LockscreenEntrypoint from './lockscreen';

document.addEventListener('DOMContentLoaded', () => {

    window.refs = {
        lockscreen: new LockscreenEntrypoint()
    };

});