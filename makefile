install:
	mkdir -p ~/.config/micro/plug/runny/help
	cp repo.json ~/.config/micro/plug/runny/repo.json
	cp runny.lua ~/.config/micro/plug/runny/runny.lua
	cp help/runnyhelp.md ~/.config/micro/plug/runny/help/runnyhelp.md

uninstall:
	rm -r ~/.config/micro/plug/runny