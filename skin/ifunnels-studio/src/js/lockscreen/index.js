export default class LockscreenEntrypoint {
    constructor() {
        this.init();
    }

    async init() {
        if( document.querySelector('.lockscreen') !== null ) {
            const {default: Lockscreen} = await import( /* webpackChunkName: "lockscreen" */ './lockscreen' );
            new Lockscreen();
        }
    }
}