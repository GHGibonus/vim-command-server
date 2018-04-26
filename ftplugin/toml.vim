if bufname("%") ==# "Cargo.toml"
	let b:build_cmd = "cargo check"
	let b:test_cmd = "cargo test"
	let b:run_cmd = "cargo run"
endif
