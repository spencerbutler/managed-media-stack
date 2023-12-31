## plex ports
- https://support.plex.tv/articles/201543147-what-network-ports-do-i-need-to-allow-through-my-firewall/

- 32400:32400/tcp # access to the Plex Media Server) [required]
- 3005:3005/tcp   # plex
- 8324:8324/tcp   # (controlling Plex for Roku via Plex Companion)
- 32469:32469/tcp # (access to the Plex DLNA Server)
- 1900:1900/udp   # (access to the Plex DLNA Server)
- 32410:32410/udp # (current GDM network discovery)
- 32412:32412/udp # (current GDM network discovery)
- 32413:32413/udp # (current GDM network discovery)
- 32414:32414/udp # (current GDM network discovery)
- 5353:5353/udp   # (older Bonjour/Avahi network discovery)

