# Chia

If you have e.g. a 1TB ssd drive as your temp directory, you have room to run 2 plots in parallel and store the finished plots on the SSD as well.
If you store the finished plots on the SSD, the plotting will finish faster and be ready for the next plots. All you have to do is move the finished plots
off the SSD to the final destination to make room for the next round. This script automates the moving of plots off your temp drive. Works on both Linux and Windows.

PS /home/foijord> ./plotmover.ps1 -TempDir /mnt/temp -DestDir /mnt/plots
Finished plots will be moved from /mnt/temp to /mnt/plots
