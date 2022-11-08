import * as PIXI from 'pixi.js';

export class Game {
    constructor() {
        this.app = new PIXI.Application({ backgroundColor: 0x1099bb });
    }

    header() {
        document.body.appendChild(this.app.view);
        // Scale mode for all textures, will retain pixelation
        PIXI.settings.SCALE_MODE = PIXI.SCALE_MODES.NEAREST;
        // Update with the cancel button
        const sprite = PIXI.Sprite.from('images/bullet.png');

        // Set the initial position
        sprite.anchor.set(0.5);
        sprite.x = this.app.screen.width - (this.app.screen.width / 25);
        sprite.y = this.app.screen.height / 25;

        // Opt-in to interactivity
        sprite.interactive = true;
        // Shows hand cursor
        sprite.buttonMode = true;

        // Alternatively, use the mouse & touch events:
        sprite.on('click', onClick); // mouse-only
        // sprite.on('tap', onClick); // touch-only
        this.app.stage.addChild(sprite);
    }

}

function onClick() {
    console.log("Send Cancel Event")
    // sprite.scale.x *= 1.25;
    // sprite.scale.y *= 1.25;
}