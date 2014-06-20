echo save_program('bin\pl.cmd', [ goal = '''$welcome''', toplevel = prolog]). halt. | runtime\PC\pl -f none -B
echo forall(library_directory(X), ((exists_directory(X) , write('Index for '), write(X), nl, make_library_index(X)) ; true)). |  runtime\PC\pl
