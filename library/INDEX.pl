/*  $Id$

    Creator: make/0

    Purpose: Provide index for autoload
*/

index((am_match), 1, am_match, am_match).
index((am_compile), 1, am_match, am_match).
index((am_bagof), 4, am_match, am_match).
index(('$arch'), 2, backward_compatibility, backcomp).
index(('$version'), 1, backward_compatibility, backcomp).
index(('$home'), 1, backward_compatibility, backcomp).
index(('$argv'), 1, backward_compatibility, backcomp).
index((displayq), 1, backward_compatibility, backcomp).
index((displayq), 2, backward_compatibility, backcomp).
index((concat), 3, backward_compatibility, backcomp).
index((read_variables), 2, backward_compatibility, backcomp).
index((read_variables), 3, backward_compatibility, backcomp).
index((feature), 2, backward_compatibility, backcomp).
index((set_feature), 2, backward_compatibility, backcomp).
index((substring), 4, backward_compatibility, backcomp).
index((flush), 0, backward_compatibility, backcomp).
index((check), 0, check, check).
index((list_undefined), 0, check, check).
index((list_autoload), 0, check, check).
index((list_redefined), 0, check, check).
index((check_old_select), 0, checkselect, checkselect).
index((is_alnum), 1, ctypes, ctypes).
index((is_alpha), 1, ctypes, ctypes).
index((is_ascii), 1, ctypes, ctypes).
index((is_cntrl), 1, ctypes, ctypes).
index((is_csym), 1, ctypes, ctypes).
index((is_csymf), 1, ctypes, ctypes).
index((is_digit), 1, ctypes, ctypes).
index((is_digit), 3, ctypes, ctypes).
index((is_endfile), 1, ctypes, ctypes).
index((is_endline), 1, ctypes, ctypes).
index((is_graph), 1, ctypes, ctypes).
index((is_lower), 1, ctypes, ctypes).
index((is_newline), 1, ctypes, ctypes).
index((is_newpage), 1, ctypes, ctypes).
index((is_paren), 2, ctypes, ctypes).
index((is_period), 1, ctypes, ctypes).
index((is_print), 1, ctypes, ctypes).
index((is_quote), 1, ctypes, ctypes).
index((is_space), 1, ctypes, ctypes).
index((is_upper), 1, ctypes, ctypes).
index((is_white), 1, ctypes, ctypes).
index((to_lower), 2, ctypes, ctypes).
index((to_upper), 2, ctypes, ctypes).
index((dde_request), 3, win_dde, dde).
index((dde_execute), 2, win_dde, dde).
index((dde_poke), 3, win_dde, dde).
index((dde_register_service), 2, win_dde, dde).
index((dde_unregister_service), 1, win_dde, dde).
index((dde_current_service), 2, win_dde, dde).
index((dde_current_connection), 2, win_dde, dde).
index((display), 1, edinburgh, edinburgh).
index((display), 2, edinburgh, edinburgh).
index((unknown), 2, edinburgh, edinburgh).
index((debug), 0, edinburgh, edinburgh).
index((nodebug), 0, edinburgh, edinburgh).
index((edit), 1, prolog_edit, edit).
index(('$editor_load_code'), 2, emacs_interface, emacs_interface).
index((find_predicate1), 2, emacs_interface, emacs_interface).
index((emacs_consult), 1, emacs_interface, emacs_interface).
index((emacs_dabbrev_atom), 1, emacs_interface, emacs_interface).
index((emacs_complete_atom), 1, emacs_interface, emacs_interface).
index((emacs_previous_command), 0, emacs_interface, emacs_interface).
index((emacs_next_command), 0, emacs_interface, emacs_interface).
index((call_emacs), 1, emacs_interface, emacs_interface).
index((call_emacs), 2, emacs_interface, emacs_interface).
index((running_under_emacs_interface), 0, emacs_interface, emacs_interface).
index((explain), 1, prolog_explain, explain).
index((explain), 2, prolog_explain, explain).
index((can_open_file), 2, files, files).
index((reset_gensym), 0, gensym, gensym).
index((reset_gensym), 1, gensym, gensym).
index((gensym), 2, gensym, gensym).
index((help), 1, online_help, help).
index((help), 0, online_help, help).
index((apropos), 1, online_help, help).
index((predicate), 5, help_index, helpidx).
index((section), 4, help_index, helpidx).
index((function), 3, help_index, helpidx).
index((listing), 0, prolog_listing, listing).
index((listing), 1, prolog_listing, listing).
index((portray_clause), 1, prolog_listing, listing).
index((www_open_url), 1, netscape, netscape).
index((contains_term), 2, occurs, occurs).
index((contains_var), 2, occurs, occurs).
index((free_of_term), 2, occurs, occurs).
index((free_of_var), 2, occurs, occurs).
index((occurrences_of_term), 3, occurs, occurs).
index((occurrences_of_var), 3, occurs, occurs).
index((sub_term), 2, occurs, occurs).
index((sub_var), 2, occurs, occurs).
index((list_to_ord_set), 2, ordsets, ordsets).
index((ord_intersect), 2, ordsets, ordsets).
index((ord_add_element), 3, ordsets, ordsets).
index((ord_subset), 2, ordsets, ordsets).
index((ord_union), 3, ordsets, ordsets).
index((oset_is), 1, oset, oset).
index((oset_union), 3, oset, oset).
index((oset_int), 3, oset, oset).
index((oset_diff), 3, oset, oset).
index((oset_dint), 2, oset, oset).
index((oset_dunion), 2, oset, oset).
index((oset_addel), 3, oset, oset).
index((oset_delel), 3, oset, oset).
index((oset_power), 2, oset, oset).
index((progman_groups), 1, progman, progman).
index((progman_group_info), 3, progman, progman).
index((progman_make_group), 1, progman, progman).
index((progman_make_group), 2, progman, progman).
index((progman_make_item), 4, progman, progman).
index((progman_make_item), 5, progman, progman).
index((progman_setup), 0, progman, progman).
index((load_foreign_files), 0, qp_foreign, qpforeign).
index((load_foreign_files), 2, qp_foreign, qpforeign).
index((load_foreign_files), 3, qp_foreign, qpforeign).
index((make_shared_object), 3, qp_foreign, qpforeign).
index((make_foreign_wrapper_file), 1, qp_foreign, qpforeign).
index((make_foreign_wrapper_file), 2, qp_foreign, qpforeign).
index((qsave_program), 1, qsave, qsave).
index((qsave_program), 2, qsave, qsave).
index((unix), 1, quintus, quintus).
index((abs), 2, quintus, quintus).
index((sin), 2, quintus, quintus).
index((cos), 2, quintus, quintus).
index((tan), 2, quintus, quintus).
index((log), 2, quintus, quintus).
index((log10), 2, quintus, quintus).
index((pow), 3, quintus, quintus).
index((ceiling), 2, quintus, quintus).
index((floor), 2, quintus, quintus).
index((round), 2, quintus, quintus).
index((acos), 2, quintus, quintus).
index((asin), 2, quintus, quintus).
index((atan), 2, quintus, quintus).
index((atan2), 3, quintus, quintus).
index((sign), 2, quintus, quintus).
index((sqrt), 2, quintus, quintus).
index((random), 3, quintus, quintus).
index((genarg), 3, quintus, quintus).
index((mode), 1, quintus, quintus).
index((public), 1, quintus, quintus).
index((meta_predicate), 1, quintus, quintus).
index((no_style_check), 1, quintus, quintus).
index((otherwise), 0, quintus, quintus).
index((numbervars), 3, quintus, quintus).
index((subsumes_chk), 2, quintus, quintus).
index((simple), 1, quintus, quintus).
index((prolog_flag), 2, quintus, quintus).
index((date), 1, quintus, quintus).
index((current_stream), 3, quintus, quintus).
index((stream_position), 3, quintus, quintus).
index((skip_line), 0, quintus, quintus).
index((skip_line), 1, quintus, quintus).
index((compile), 1, quintus, quintus).
index((atom_char), 2, quintus, quintus).
index((midstring), 3, quintus, quintus).
index((midstring), 4, quintus, quintus).
index((midstring), 5, quintus, quintus).
index((midstring), 6, quintus, quintus).
index((readln), 1, readln, readln).
index((readln), 2, readln, readln).
index((readln), 5, readln, readln).
index((read_line_to_codes), 2, read_util, readutil).
index((read_line_to_codes), 3, read_util, readutil).
index((read_stream_to_codes), 2, read_util, readutil).
index((read_stream_to_codes), 3, read_util, readutil).
index((read_file_to_codes), 3, read_util, readutil).
index((read_file_to_terms), 3, read_util, readutil).
index((registry_get_key), 2, win_registry, registry).
index((registry_get_key), 3, win_registry, registry).
index((registry_set_key), 2, win_registry, registry).
index((registry_set_key), 3, win_registry, registry).
index((registry_delete_key), 1, win_registry, registry).
index((registry_lookup_key), 3, win_registry, registry).
index((shell_register_file_type), 4, win_registry, registry).
index((shell_register_dde), 6, win_registry, registry).
index((shell_register_prolog), 1, win_registry, registry).
index((ls), 0, shell, shell).
index((ls), 1, shell, shell).
index((cd), 0, shell, shell).
index((cd), 1, shell, shell).
index((pushd), 0, shell, shell).
index((pushd), 1, shell, shell).
index((dirs), 0, shell, shell).
index((pwd), 0, shell, shell).
index((popd), 0, shell, shell).
index((mv), 2, shell, shell).
index((rm), 1, shell, shell).
index((load_foreign_library), 1, shlib, shlib).
index((load_foreign_library), 2, shlib, shlib).
index((unload_foreign_library), 1, shlib, shlib).
index((unload_foreign_library), 1, shlib, shlib).
index((current_foreign_library), 2, shlib, shlib).
index((reload_foreign_libraries), 0, shlib, shlib).
index((time), 1, prolog_statistics, statistics).
index((profiler), 2, prolog_statistics, statistics).
index((show_profile), 1, prolog_statistics, statistics).
index((profile), 3, prolog_statistics, statistics).
index((lock_predicate), 2, swi_system_utilities, system).
index((unlock_predicate), 2, swi_system_utilities, system).
index((system_mode), 1, swi_system_utilities, system).
index((system_module), 0, swi_system_utilities, system).
index((threads), 0, thread_util, threadutil).
index((interactor), 0, thread_util, threadutil).
index((attach_console), 0, thread_util, threadutil).
index((tty_clear), 0, tty, tty).
index((tty_flash), 0, tty, tty).
index((menu), 3, tty, tty).
index((parse_url), 2, url, url).
index((parse_url), 3, url, url).
index((global_url), 3, url, url).
index((http_location), 2, url, url).
index((www_form_encode), 2, url, url).
index((parse_url_search), 2, url, url).
index((wise_install), 0, wise_install, wise).
index((wise_install_xpce), 0, wise_install, wise).
