start:
	pg_ctl -D .pg -l logfile start

archive:
	tar --exclude .git --exclude .pg --exclude logfile --exclude Session.vim --exclude deps --exclude _build --exclude .elixir-tools --exclude .elixir_ls --exclude .lexical --exclude check_point* -cvzf check_point.tar.gz ../check_point



