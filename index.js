var five = require('johnny-five'),
    board,led;

board = new five.Board();
board.on('ready', function(){
  led = new five.Led(13);
  led.strobe();

  this.repl.inject({
    led: led
  })
});
