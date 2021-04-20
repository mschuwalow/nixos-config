let
  user =
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKF2p1cSgUf+MSuS3WmeB94mvrgqWs4ej3aTYf+8txUm1ugFA5fCYCXBTEcDGp/ToDc6yYU2HJiT8ViwNt6+Ndg8TcGe3+4Va7Eje4kh8r9tBROfeyoPabasafit0PjVrZVpGwSk61O/j6J0S8+coBbKIvMak5/5FcO1M5k75vW7Y+MiCzufDz8rzHt/Cu36S8lVRLEJEB5oeAQcYiNqmxPrfyl9tUItpgOjgUFdpm8nqSt0qHrrN+6sQ8wDodHW9/jvhKCGcejJ5izFaKtCpnQPBw3IwFwMywubC0222F5TljwB4frLT/p9WVQWAnpttEb2yPyaQnsDUZI3v/v+DSjI06ljEyFpxT8LDbT3DUIec2x9aR3uHkeStBYy+ENzPDRuiVbDf2tYGYzBuFxxt/AY8KGh9xyNShePFSbGsvyFB/qGHUBslbQGaxa9lcffjxWJv/eBGKezOeM69+vm+Cm3WTNEKczN8FLL/1B+rertaVciSUuPhRMQAyXKX+gs8= root@mschuwalow-desktop";
  desktop =
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4tId5UtevBKyrBu6/0nSKe9QqyTrMom522qcUCkMA/EjVqn6pRlvAUoMirY51WK8ytTcDWSF9pCGPy4583wIeF5k9Hden1K/lUrBk/rQWbdEvt2VMyqiBdx54sVcbrQaoEctJz0aRIzBB5X5T9NaFN696XPtti8v/9o9WcqfedNSCZlP1KzAp/qv3mh8WIYZg5InBUw0/7kYMisI5McbiXemeKYcUm7MzdpozqBso/lVblRBP2771UVp7Q0L/4zbGJrf05O4SK2a2M9s4IxLnKuOftMMBkul00jbG0YDXmhnBQBOCkRqK+qq4YLqvL6gfF+RAW0kpODEJJDJmnBj+8Sr1QPgvvt/l0e9PX2t+M0ydpAx7wkBXhhV05df4s4GwxaRs727cDtvaGFvCMaQ5GY+eGxsDFfXmCHpnM4zYhH+AaRdKwA4KJ+vGzdIJ33NAC8NHmc52IiOpd6Y9abecY6SSlNM2FK25cAkZc5PDuIXLRBXgvoRZ7TYz0oeedLER95Mwjwy3QNq9LuPE0DO1RQ9N+V5HleViB6/giGONUAwa86mia3geRJZRF48U7WkmcXrJJOOYT7VGN0916jlxOLpHnnqTN7wDIJm//LmcvbclD3yuvAqJj52C6Pe5c+hq+EZyLCEnZ9UYJoy5YBUDIT3OMYLuMuRl1kH7fmKAXQ== root@mschuwalow-desktop";
  all = [ user desktop ];
in {
  "vpn/purevpn.key.age".publicKeys = all;
  "vpn/purevpn.ovpn.age".publicKeys = all;
  "users/mschuwalow.age".publicKeys = all;
  "users/pzhang.age".publicKeys = all;
  "users/root.age".publicKeys = all;
  "ssh/github_rsa.age".publicKeys = all;
}