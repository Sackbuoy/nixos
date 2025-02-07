main:
	@if [ -n "$$(git status --porcelain --untracked-files=no)" ]; then \
		echo "Unstaged changes exist; stashing and building HEAD"; \
		git stash; \
		sudo nixos-rebuild boot --flake . --profile-name "main-old"; \
		echo "Building latest changes"; \
		git stash pop; \
		sudo nixos-rebuild boot --flake . --profile-name "main-latest"; \
	else \
		echo "Working directory clean; checking out and rebuilding previous commit"; \
		git checkout HEAD~1; \
		sudo nixos-rebuild boot --flake . --profile-name "main-old"; \
		echo "Building latest changes"; \
		git checkout main; \
		sudo nixos-rebuild boot --flake . --profile-name "main-latest"; \
	fi

dev:
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "Unstaged changes exist; stashing and building previous HEAD"; \
		git stash; \
		sudo nixos-rebuild boot --flake . --profile-name "dev-old"; \
		git stash pop; \
		echo "Building latest changes"; \
		sudo nixos-rebuild boot --flake . --profile-name "dev-latest"; \
	else \
		echo "Working directory clean; checking out and rebuilding previous commit"; \
		git checkout HEAD~1; \
		sudo nixos-rebuild boot --flake . --profile-name "dev-old"; \
		echo "Building latest changes"; \
		sudo nixos-rebuild boot --flake . --profile-name "dev-latest"; \
	fi
