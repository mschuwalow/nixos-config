let
    user = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKF2p1cSgUf+MSuS3WmeB94mvrgqWs4ej3aTYf+8txUm1ugFA5fCYCXBTEcDGp/ToDc6yYU2HJiT8ViwNt6+Ndg8TcGe3+4Va7Eje4kh8r9tBROfeyoPabasafit0PjVrZVpGwSk61O/j6J0S8+coBbKIvMak5/5FcO1M5k75vW7Y+MiCzufDz8rzHt/Cu36S8lVRLEJEB5oeAQcYiNqmxPrfyl9tUItpgOjgUFdpm8nqSt0qHrrN+6sQ8wDodHW9/jvhKCGcejJ5izFaKtCpnQPBw3IwFwMywubC0222F5TljwB4frLT/p9WVQWAnpttEb2yPyaQnsDUZI3v/v+DSjI06ljEyFpxT8LDbT3DUIec2x9aR3uHkeStBYy+ENzPDRuiVbDf2tYGYzBuFxxt/AY8KGh9xyNShePFSbGsvyFB/qGHUBslbQGaxa9lcffjxWJv/eBGKezOeM69+vm+Cm3WTNEKczN8FLL/1B+rertaVciSUuPhRMQAyXKX+gs8= root@mschuwalow-desktop";
in
{
    "vpn/purevpn.key.age".publicKeys = [ user ];
    "vpn/purevpn.ovpn.age".publicKeys = [ user ];
    "users/mschuwalow.age".publicKeys = [ user ];
    "users/pzhang.age".publicKeys = [ user ];
    "users/root.age".publicKeys = [ user ];
}