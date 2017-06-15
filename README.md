# LXDE VNC

Minimal [LXDE](http://lxde.org) desktop with the following features:
 - Argentine localtime
 - [supervior](http://supervisord.org/) (process manager)
    - precofngiured services:
        - ssh (running on port 2222)
        - vnc to lxde environment (running on port 5901)
    - Add your services in: `/ets/supervisord/conf.d`

## How to use

```
docker run -p 5901:5901 -p 2222:22 -v $(pwd):/root/shared d3f0/lxdevnc:latest
```

### Ports to connect to services

Assuming you've used the given 5901:5901 and 2222:22 examples from previous section, the `-p`, sahre port, refer to:
 * `5901` first vnc screen, you can access remote screen with any VNC client such as [Chrome's VNC client](https://chrome.google.com/webstore/detail/vnc%C2%AE-viewer-for-google-ch/iabmpiboiopbgfabjmgeedhcmjenhbla), `apt-get instal tigervnc`, `krdc` on KDE, `vinagre` on GNOME, etc.

 If your client supports ursl, use the following:

    vnc://localhost:5901

 * `2222` ssh access, you can ssh to get a terminal inside the cotainer.

    To connect run the following line:

    ```
    ssh -p 2222 root@localhost
    ```

    - To access through X11 screen sharing:

    ```
    ssh -X -p 2222 root@localhost pcmanfm
    ```

    You can use any of the installed lxde programs as argument.



## File share

The `-v` in the how to use section, refers to a shared volume. This command will mount the current directory, expresed by `$(pwd)` in `/root/shared`.