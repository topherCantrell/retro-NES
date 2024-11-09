## Serial connection

My experiments show that the OUT signal D0 and the input signals D0, D3, and D4 are available at Port 1 and Port2.

<img src="Port2.jpg" width=600>

I ordered an controller expansion cable and hacked the controller end to expose the signals. The
colors from my cable are shown below.

On my hacked cable, the colors are:
  - OUT (4016 D0): Black - the NES writes to 4016 to send this signal to the Pi
  - D0 (4016 D0): Green - the NES reads from 4016 to read this signal from the Pi
  - D3 (4016 D3): Orange - the NES reads from 4016 to read this signal from the Pi
  - D4 (4016 D4): Brown - the NES reads from 4016 to read this signal from the Pi

Level shifter

NES code

Python monitor program 