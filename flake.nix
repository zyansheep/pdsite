{
	description = "Package the hello repeater.";

	outputs = { self, nixpkgs }: {
		packages.x86_64-linux.pdsite =
			let pkgs = import nixpkgs { system = "x86_64-linux"; };
				script = ''
					export PATH="${nixpkgs.lib.makeBinPath [pkgs.pandoc pkgs.tree]}:$PATH"
					${builtins.readFile ./bin/pdsite}
				'';
			in pkgs.stdenv.mkDerivation {
				pname = "pdsite";
				version = "1.0.0";
				src = ./.;
				buildInputs = [ pkgs.makeWrapper ];
				installPhase = ''
					mkdir -p $out/bin
					cp -r $src/* $out
					rm $out/bin/pdsite
					cp ${(pkgs.writeShellScript "pdsite" script).out} $out/bin/pdsite
				'';
			};
		defaultPackage.x86_64-linux = self.packages.x86_64-linux.pdsite; # <- add this
	};
}