{ config, lib, pkgs, ... }:

let
	rev = "c18984c452013ff0edb3d67ab0a1a245333dd4ce";
in
{
	imports = [
		"${
			fetchTarball {
				url = "https://github.com/rycee/home-manager/archive/${rev}.tar.gz";
				sha256 = "10knp7bl6ql14szkgmc1lfb649i22ab21kkq8pc0gjrdsvpgnlsj";
			}
		}/nixos"
	];
}
