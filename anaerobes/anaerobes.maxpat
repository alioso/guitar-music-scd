{
	"patcher": {
		"fileversion": 1,
		"appversion": {
			"major": 9,
			"minor": 0,
			"revision": 8,
			"architecture": "x64",
			"modernui": 1
		},
		"classnamespace": "dsp.toplevel",
		"rect": [
			50.0,
			80.0,
			1600.0,
			950.0
		],
		"gridsize": [
			15.0,
			15.0
		],
		"boxes": [
			{
				"box": {
					"id": "lbl_input",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						50,
						20,
						120,
						22
					],
					"outlettype": [],
					"text": "=== INPUT ==="
				}
			},
			{
				"box": {
					"id": "ezdac",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 0,
					"patching_rect": [
						200,
						40,
						50,
						22
					],
					"outlettype": [],
					"text": "ezdac~"
				}
			},
			{
				"box": {
					"id": "lbl_ezdac",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						260,
						44,
						170,
						22
					],
					"outlettype": [],
					"text": "<-- click to enable audio"
				}
			},
			{
				"box": {
					"id": "adc",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						50,
						80,
						62,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "adc~ 1"
				}
			},
			{
				"box": {
					"id": "dry_gain",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						50,
						120,
						69,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.35"
				}
			},
			{
				"box": {
					"id": "lbl_dry",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						130,
						120,
						140,
						22
					],
					"outlettype": [],
					"text": "dry guitar (center)"
				}
			},
			{
				"box": {
					"id": "tapin",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						50,
						160,
						104,
						22
					],
					"outlettype": [
						"tapconnect"
					],
					"text": "tapin~ 30000"
				}
			},
			{
				"box": {
					"id": "rev_buf_def",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						320,
						80,
						160,
						22
					],
					"outlettype": [],
					"text": "buffer~ rev_buf 3000"
				}
			},
			{
				"box": {
					"id": "rev_rec",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						320,
						115,
						125,
						22
					],
					"outlettype": [
						""
					],
					"text": "record~ rev_buf"
				}
			},
			{
				"box": {
					"id": "rev_groove",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						320,
						155,
						125,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "groove~ rev_buf"
				}
			},
			{
				"box": {
					"id": "rev_init_delay",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						430,
						80,
						83,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "delay 200"
				}
			},
			{
				"box": {
					"id": "rev_rec_loop",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						430,
						115,
						62,
						22
					],
					"outlettype": [
						""
					],
					"text": "loop 1"
				}
			},
			{
				"box": {
					"id": "rev_rec_on",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						115,
						27,
						22
					],
					"outlettype": [
						""
					],
					"text": "1"
				}
			},
			{
				"box": {
					"id": "rev_grv_loop",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						430,
						150,
						62,
						22
					],
					"outlettype": [
						""
					],
					"text": "loop 1"
				}
			},
			{
				"box": {
					"id": "rev_grv_rate",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						150,
						76,
						22
					],
					"outlettype": [
						""
					],
					"text": "rate -1."
				}
			},
			{
				"box": {
					"id": "rev_grv_on",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						570,
						150,
						27,
						22
					],
					"outlettype": [
						""
					],
					"text": "1"
				}
			},
			{
				"box": {
					"id": "lbl_timer",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						250,
						20,
						200,
						22
					],
					"outlettype": [],
					"text": "=== TIMER (8min = 480s) ==="
				}
			},
			{
				"box": {
					"id": "start_btn",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						250,
						40,
						24,
						24
					],
					"outlettype": [
						"bang"
					],
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "lbl_start",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						280,
						44,
						50,
						22
					],
					"outlettype": [],
					"text": "START"
				}
			},
			{
				"box": {
					"id": "reset_btn",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						330,
						40,
						24,
						24
					],
					"outlettype": [
						"bang"
					],
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "lbl_reset",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						360,
						44,
						80,
						22
					],
					"outlettype": [],
					"text": "RESET/STOP"
				}
			},
			{
				"box": {
					"id": "msg_start",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						250,
						75,
						27,
						22
					],
					"outlettype": [
						""
					],
					"text": "1"
				}
			},
			{
				"box": {
					"id": "msg_stop",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						330,
						75,
						27,
						22
					],
					"outlettype": [
						""
					],
					"text": "0"
				}
			},
			{
				"box": {
					"id": "metro",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						250,
						105,
						76,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "metro 50"
				}
			},
			{
				"box": {
					"id": "counter",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 4,
					"patching_rect": [
						250,
						135,
						69,
						22
					],
					"outlettype": [
						"int",
						"",
						"",
						"int"
					],
					"text": "counter"
				}
			},
			{
				"box": {
					"id": "ticks_to_ms",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						250,
						170,
						48,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "* 50"
				}
			},
			{
				"box": {
					"id": "ms_to_sec",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						250,
						200,
						69,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 1000."
				}
			},
			{
				"box": {
					"id": "time_display",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						250,
						235,
						70,
						22
					],
					"outlettype": [
						"",
						"bang"
					],
					"format": 6,
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "lbl_seconds",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						325,
						235,
						60,
						22
					],
					"outlettype": [],
					"text": "seconds"
				}
			},
			{
				"box": {
					"id": "sec_to_min",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						390,
						235,
						55,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 60."
				}
			},
			{
				"box": {
					"id": "min_display",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						390,
						265,
						60,
						22
					],
					"outlettype": [
						"",
						"bang"
					],
					"format": 6,
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "lbl_minutes",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						455,
						265,
						60,
						22
					],
					"outlettype": [],
					"text": "minutes"
				}
			},
			{
				"box": {
					"id": "evo_sub",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						250,
						300,
						55,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "- 10."
				}
			},
			{
				"box": {
					"id": "evo_div",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						250,
						330,
						62,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 170."
				}
			},
			{
				"box": {
					"id": "evo_clip",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						250,
						360,
						90,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "clip 0. 1."
				}
			},
			{
				"box": {
					"id": "lbl_evo",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						330,
						360,
						110,
						22
					],
					"outlettype": [],
					"text": "evolution (0..1)"
				}
			},
			{
				"box": {
					"id": "onset_div",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						410,
						300,
						48,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 3."
				}
			},
			{
				"box": {
					"id": "onset_clip",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						410,
						330,
						90,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "clip 0. 1."
				}
			},
			{
				"box": {
					"id": "lbl_onset",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						490,
						330,
						90,
						22
					],
					"outlettype": [],
					"text": "onset (0..1)"
				}
			},
			{
				"box": {
					"id": "chaos_expr",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						410,
						370,
						430,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr max(0., min(1., ($f1-120.)/165.)) * (1.-max(0., min(1., ($f1-285.)/135.)))"
				}
			},
			{
				"box": {
					"id": "chaos_sig",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						410,
						405,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "sig~ 0."
				}
			},
			{
				"box": {
					"id": "lbl_chaos",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						474,
						370,
						160,
						22
					],
					"outlettype": [],
					"text": "chaos arc (peaks ~4:45)"
				}
			},
			{
				"box": {
					"id": "rev_sub",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						570,
						370,
						62,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "- 360."
				}
			},
			{
				"box": {
					"id": "rev_div",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						570,
						400,
						55,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 30."
				}
			},
			{
				"box": {
					"id": "rev_clip",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						570,
						430,
						90,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "clip 0. 1."
				}
			},
			{
				"box": {
					"id": "rev_sig",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						570,
						460,
						69,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "sig~ 0."
				}
			},
			{
				"box": {
					"id": "lbl_rev",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						634,
						370,
						160,
						22
					],
					"outlettype": [],
					"text": "reverse arc (last 2min)"
				}
			},
			{
				"box": {
					"id": "lbl_voices",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						500,
						20,
						200,
						22
					],
					"outlettype": [],
					"text": "=== VOICE PARAMETERS ==="
				}
			},
			{
				"box": {
					"id": "lbl_v1",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						500,
						40,
						250,
						22
					],
					"outlettype": [],
					"text": "--- G1: pan=32.0, vol=3.0 ---"
				}
			},
			{
				"box": {
					"id": "fs_expr_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						65,
						310,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 1.0 + $f1 * 3.0 * (1. + $f2 * 0.6)"
				}
			},
			{
				"box": {
					"id": "fs_pack_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						95,
						85,
						22
					],
					"outlettype": [
						""
					],
					"text": "pack 0. 100"
				}
			},
			{
				"box": {
					"id": "fs_line_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						500,
						125,
						70,
						22
					],
					"outlettype": [
						"signal",
						"bang"
					],
					"text": "line~ 0."
				}
			},
			{
				"box": {
					"id": "vol_expr_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						720,
						65,
						160,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr $f1 * 3.0"
				}
			},
			{
				"box": {
					"id": "vol_pack_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						720,
						95,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "pack 0. 50"
				}
			},
			{
				"box": {
					"id": "vol_line_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						720,
						125,
						70,
						22
					],
					"outlettype": [
						"signal",
						"bang"
					],
					"text": "line~ 0."
				}
			},
			{
				"box": {
					"id": "pan_val_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						900,
						65,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 32.0"
				}
			},
			{
				"box": {
					"id": "evo_sig_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						720,
						160,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "sig~ 0."
				}
			},
			{
				"box": {
					"id": "inv_evo_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						790,
						160,
						100,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 1. - $f1"
				}
			},
			{
				"box": {
					"id": "inv_sig_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						790,
						190,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "sig~ 0."
				}
			},
			{
				"box": {
					"id": "swell_a_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						990,
						60,
						85,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.1"
				}
			},
			{
				"box": {
					"id": "swell_a_scale_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						990,
						90,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_a_bias_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						990,
						120,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_b_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1090,
						60,
						85,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.013"
				}
			},
			{
				"box": {
					"id": "swell_b_scale_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1090,
						90,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_b_bias_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1090,
						120,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_prod_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1040,
						150,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "breath_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1190,
						60,
						85,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.11"
				}
			},
			{
				"box": {
					"id": "breath_scale_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1190,
						90,
						65,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.15"
				}
			},
			{
				"box": {
					"id": "breath_bias_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1190,
						120,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 1.0"
				}
			},
			{
				"box": {
					"id": "dyn_env_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1140,
						150,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "wobble_osc_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						60,
						90,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.37"
				}
			},
			{
				"box": {
					"id": "wobble_cm_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						95,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "wobble_d_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						125,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "wobble_sum_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						155,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "rev_gate_osc_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						60,
						90,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.019"
				}
			},
			{
				"box": {
					"id": "rev_gate_scale_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						92,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "rev_gate_bias_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						122,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.5"
				}
			},
			{
				"box": {
					"id": "rev_gate_sig_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						152,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "lbl_v2",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						500,
						240,
						250,
						22
					],
					"outlettype": [],
					"text": "--- G2: pan=-28.0, vol=3.0 ---"
				}
			},
			{
				"box": {
					"id": "fs_expr_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						265,
						310,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr -1.5 + $f1 * -3.5 * (1. + $f2 * 0.7)"
				}
			},
			{
				"box": {
					"id": "fs_pack_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						295,
						85,
						22
					],
					"outlettype": [
						""
					],
					"text": "pack 0. 100"
				}
			},
			{
				"box": {
					"id": "fs_line_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						500,
						325,
						70,
						22
					],
					"outlettype": [
						"signal",
						"bang"
					],
					"text": "line~ 0."
				}
			},
			{
				"box": {
					"id": "vol_expr_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						720,
						265,
						160,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr $f1 * 3.0"
				}
			},
			{
				"box": {
					"id": "vol_pack_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						720,
						295,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "pack 0. 50"
				}
			},
			{
				"box": {
					"id": "vol_line_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						720,
						325,
						70,
						22
					],
					"outlettype": [
						"signal",
						"bang"
					],
					"text": "line~ 0."
				}
			},
			{
				"box": {
					"id": "pan_val_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						900,
						265,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr -28.0"
				}
			},
			{
				"box": {
					"id": "evo_sig_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						720,
						360,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "sig~ 0."
				}
			},
			{
				"box": {
					"id": "inv_evo_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						790,
						360,
						100,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 1. - $f1"
				}
			},
			{
				"box": {
					"id": "inv_sig_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						790,
						390,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "sig~ 0."
				}
			},
			{
				"box": {
					"id": "swell_a_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						990,
						260,
						85,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.13"
				}
			},
			{
				"box": {
					"id": "swell_a_scale_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						990,
						290,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_a_bias_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						990,
						320,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_b_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1090,
						260,
						85,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.017"
				}
			},
			{
				"box": {
					"id": "swell_b_scale_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1090,
						290,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_b_bias_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1090,
						320,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_prod_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1040,
						350,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "breath_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1190,
						260,
						85,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.17"
				}
			},
			{
				"box": {
					"id": "breath_scale_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1190,
						290,
						65,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.15"
				}
			},
			{
				"box": {
					"id": "breath_bias_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1190,
						320,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 1.0"
				}
			},
			{
				"box": {
					"id": "dyn_env_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1140,
						350,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "wobble_osc_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						260,
						90,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.53"
				}
			},
			{
				"box": {
					"id": "wobble_cm_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						295,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "wobble_d_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						325,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.6"
				}
			},
			{
				"box": {
					"id": "wobble_sum_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						355,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "rev_gate_osc_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						260,
						90,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.023"
				}
			},
			{
				"box": {
					"id": "rev_gate_scale_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						292,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "rev_gate_bias_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						322,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.5"
				}
			},
			{
				"box": {
					"id": "rev_gate_sig_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						352,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "lbl_v3",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						500,
						440,
						250,
						22
					],
					"outlettype": [],
					"text": "--- G3: pan=78.0, vol=2.8 ---"
				}
			},
			{
				"box": {
					"id": "fs_expr_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						465,
						310,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 2.0 + $f1 * 4.0 * (1. + $f2 * 0.8)"
				}
			},
			{
				"box": {
					"id": "fs_pack_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						495,
						85,
						22
					],
					"outlettype": [
						""
					],
					"text": "pack 0. 100"
				}
			},
			{
				"box": {
					"id": "fs_line_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						500,
						525,
						70,
						22
					],
					"outlettype": [
						"signal",
						"bang"
					],
					"text": "line~ 0."
				}
			},
			{
				"box": {
					"id": "vol_expr_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						720,
						465,
						160,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr $f1 * 2.8"
				}
			},
			{
				"box": {
					"id": "vol_pack_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						720,
						495,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "pack 0. 50"
				}
			},
			{
				"box": {
					"id": "vol_line_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						720,
						525,
						70,
						22
					],
					"outlettype": [
						"signal",
						"bang"
					],
					"text": "line~ 0."
				}
			},
			{
				"box": {
					"id": "pan_val_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						900,
						465,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 78.0"
				}
			},
			{
				"box": {
					"id": "evo_sig_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						720,
						560,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "sig~ 0."
				}
			},
			{
				"box": {
					"id": "inv_evo_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						790,
						560,
						100,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 1. - $f1"
				}
			},
			{
				"box": {
					"id": "inv_sig_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						790,
						590,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "sig~ 0."
				}
			},
			{
				"box": {
					"id": "swell_a_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						990,
						460,
						85,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.083"
				}
			},
			{
				"box": {
					"id": "swell_a_scale_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						990,
						490,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_a_bias_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						990,
						520,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_b_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1090,
						460,
						85,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.011"
				}
			},
			{
				"box": {
					"id": "swell_b_scale_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1090,
						490,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_b_bias_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1090,
						520,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_prod_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1040,
						550,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "breath_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1190,
						460,
						85,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.07"
				}
			},
			{
				"box": {
					"id": "breath_scale_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1190,
						490,
						65,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.15"
				}
			},
			{
				"box": {
					"id": "breath_bias_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1190,
						520,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 1.0"
				}
			},
			{
				"box": {
					"id": "dyn_env_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1140,
						550,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "wobble_osc_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						460,
						90,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.67"
				}
			},
			{
				"box": {
					"id": "wobble_cm_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						495,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "wobble_d_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						525,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.4"
				}
			},
			{
				"box": {
					"id": "wobble_sum_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						555,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "rev_gate_osc_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						460,
						90,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.031"
				}
			},
			{
				"box": {
					"id": "rev_gate_scale_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						492,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "rev_gate_bias_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						522,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.5"
				}
			},
			{
				"box": {
					"id": "rev_gate_sig_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						552,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "lbl_v4",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						500,
						640,
						250,
						22
					],
					"outlettype": [],
					"text": "--- G4: pan=-75.0, vol=2.8 ---"
				}
			},
			{
				"box": {
					"id": "fs_expr_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						665,
						310,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr -2.5 + $f1 * -4.5 * (1. + $f2 * 0.9)"
				}
			},
			{
				"box": {
					"id": "fs_pack_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						695,
						85,
						22
					],
					"outlettype": [
						""
					],
					"text": "pack 0. 100"
				}
			},
			{
				"box": {
					"id": "fs_line_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						500,
						725,
						70,
						22
					],
					"outlettype": [
						"signal",
						"bang"
					],
					"text": "line~ 0."
				}
			},
			{
				"box": {
					"id": "vol_expr_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						720,
						665,
						160,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr $f1 * 2.8"
				}
			},
			{
				"box": {
					"id": "vol_pack_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						720,
						695,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "pack 0. 50"
				}
			},
			{
				"box": {
					"id": "vol_line_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						720,
						725,
						70,
						22
					],
					"outlettype": [
						"signal",
						"bang"
					],
					"text": "line~ 0."
				}
			},
			{
				"box": {
					"id": "pan_val_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						900,
						665,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr -75.0"
				}
			},
			{
				"box": {
					"id": "evo_sig_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						720,
						760,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "sig~ 0."
				}
			},
			{
				"box": {
					"id": "inv_evo_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						790,
						760,
						100,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 1. - $f1"
				}
			},
			{
				"box": {
					"id": "inv_sig_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						790,
						790,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "sig~ 0."
				}
			},
			{
				"box": {
					"id": "swell_a_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						990,
						660,
						85,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.11"
				}
			},
			{
				"box": {
					"id": "swell_a_scale_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						990,
						690,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_a_bias_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						990,
						720,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_b_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1090,
						660,
						85,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.015"
				}
			},
			{
				"box": {
					"id": "swell_b_scale_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1090,
						690,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_b_bias_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1090,
						720,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.5"
				}
			},
			{
				"box": {
					"id": "swell_prod_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1040,
						750,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "breath_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1190,
						660,
						85,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.13"
				}
			},
			{
				"box": {
					"id": "breath_scale_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1190,
						690,
						65,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.15"
				}
			},
			{
				"box": {
					"id": "breath_bias_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1190,
						720,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 1.0"
				}
			},
			{
				"box": {
					"id": "dyn_env_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1140,
						750,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "wobble_osc_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						660,
						90,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.43"
				}
			},
			{
				"box": {
					"id": "wobble_cm_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						695,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "wobble_d_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						725,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.7"
				}
			},
			{
				"box": {
					"id": "wobble_sum_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1300,
						755,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "rev_gate_osc_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						660,
						90,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.027"
				}
			},
			{
				"box": {
					"id": "rev_gate_scale_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						692,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "rev_gate_bias_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						722,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.5"
				}
			},
			{
				"box": {
					"id": "rev_gate_sig_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1420,
						752,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "lbl_audio",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						750,
						20,
						200,
						22
					],
					"outlettype": [],
					"text": "=== AUDIO PROCESSING ==="
				}
			},
			{
				"box": {
					"id": "lbl_a1",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						770,
						40,
						40,
						22
					],
					"outlettype": [],
					"text": "G1"
				}
			},
			{
				"box": {
					"id": "tapout_a_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						750,
						70,
						100,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "tapout~ 12.0"
				}
			},
			{
				"box": {
					"id": "tapout_b_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						750,
						105,
						100,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "tapout~ 1500.0"
				}
			},
			{
				"box": {
					"id": "xf_a_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						750,
						145,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "xf_b_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						800,
						145,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "xf_sum_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						770,
						180,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "freqshift_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						750,
						220,
						80,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "freqshift~"
				}
			},
			{
				"box": {
					"id": "vol_mult_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						750,
						260,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0."
				}
			},
			{
				"box": {
					"id": "sat_scale_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						815,
						260,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 1.5"
				}
			},
			{
				"box": {
					"id": "sat_add_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						815,
						288,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 1."
				}
			},
			{
				"box": {
					"id": "sat_mult_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						815,
						316,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "dyn_mult_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						750,
						330,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "rev_gated_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						870,
						370,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "rev_scaled_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						870,
						402,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.35"
				}
			},
			{
				"box": {
					"id": "rev_mix_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						750,
						440,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "pan_1",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						750,
						485,
						50,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "pan2"
				}
			},
			{
				"box": {
					"id": "lbl_a2",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						950,
						40,
						40,
						22
					],
					"outlettype": [],
					"text": "G2"
				}
			},
			{
				"box": {
					"id": "tapout_a_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						930,
						70,
						100,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "tapout~ 23.0"
				}
			},
			{
				"box": {
					"id": "tapout_b_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						930,
						105,
						100,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "tapout~ 2800.0"
				}
			},
			{
				"box": {
					"id": "xf_a_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						930,
						145,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "xf_b_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						980,
						145,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "xf_sum_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						950,
						180,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "freqshift_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						930,
						220,
						80,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "freqshift~"
				}
			},
			{
				"box": {
					"id": "vol_mult_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						930,
						260,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0."
				}
			},
			{
				"box": {
					"id": "sat_scale_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						995,
						260,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 1.5"
				}
			},
			{
				"box": {
					"id": "sat_add_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						995,
						288,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 1."
				}
			},
			{
				"box": {
					"id": "sat_mult_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						995,
						316,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "dyn_mult_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						930,
						330,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "rev_gated_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1050,
						370,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "rev_scaled_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1050,
						402,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.4"
				}
			},
			{
				"box": {
					"id": "rev_mix_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						930,
						440,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "pan_2",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						930,
						485,
						50,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "pan2"
				}
			},
			{
				"box": {
					"id": "lbl_a3",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1130,
						40,
						40,
						22
					],
					"outlettype": [],
					"text": "G3"
				}
			},
			{
				"box": {
					"id": "tapout_a_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1110,
						70,
						100,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "tapout~ 37.0"
				}
			},
			{
				"box": {
					"id": "tapout_b_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1110,
						105,
						100,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "tapout~ 4200.0"
				}
			},
			{
				"box": {
					"id": "xf_a_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1110,
						145,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "xf_b_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1160,
						145,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "xf_sum_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1130,
						180,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "freqshift_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1110,
						220,
						80,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "freqshift~"
				}
			},
			{
				"box": {
					"id": "vol_mult_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1110,
						260,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0."
				}
			},
			{
				"box": {
					"id": "sat_scale_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1175,
						260,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 1.5"
				}
			},
			{
				"box": {
					"id": "sat_add_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1175,
						288,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 1."
				}
			},
			{
				"box": {
					"id": "sat_mult_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1175,
						316,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "dyn_mult_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1110,
						330,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "rev_gated_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1230,
						370,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "rev_scaled_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1230,
						402,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.55"
				}
			},
			{
				"box": {
					"id": "rev_mix_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1110,
						440,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "pan_3",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						1110,
						485,
						50,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "pan2"
				}
			},
			{
				"box": {
					"id": "lbl_a4",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1310,
						40,
						40,
						22
					],
					"outlettype": [],
					"text": "G4"
				}
			},
			{
				"box": {
					"id": "tapout_a_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1290,
						70,
						100,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "tapout~ 48.0"
				}
			},
			{
				"box": {
					"id": "tapout_b_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1290,
						105,
						100,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "tapout~ 5500.0"
				}
			},
			{
				"box": {
					"id": "xf_a_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1290,
						145,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "xf_b_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1340,
						145,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "xf_sum_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1310,
						180,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "freqshift_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1290,
						220,
						80,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "freqshift~"
				}
			},
			{
				"box": {
					"id": "vol_mult_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1290,
						260,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0."
				}
			},
			{
				"box": {
					"id": "sat_scale_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1355,
						260,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 1.5"
				}
			},
			{
				"box": {
					"id": "sat_add_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1355,
						288,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 1."
				}
			},
			{
				"box": {
					"id": "sat_mult_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1355,
						316,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "dyn_mult_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1290,
						330,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "rev_gated_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1410,
						370,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~"
				}
			},
			{
				"box": {
					"id": "rev_scaled_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1410,
						402,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.5"
				}
			},
			{
				"box": {
					"id": "rev_mix_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1290,
						440,
						40,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "pan_4",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						1290,
						485,
						50,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "pan2"
				}
			},
			{
				"box": {
					"id": "lbl_mix",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1350,
						20,
						160,
						22
					],
					"outlettype": [],
					"text": "=== MIX & OUTPUT ==="
				}
			},
			{
				"box": {
					"id": "sum_L_12",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1350,
						70,
						34,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "sum_L_34",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1350,
						100,
						34,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "sum_L_all",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1350,
						130,
						34,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "sum_R_12",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1430,
						70,
						34,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "sum_R_34",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1430,
						100,
						34,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "sum_R_all",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1430,
						130,
						34,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "mix_L",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1350,
						170,
						34,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "mix_R",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1430,
						170,
						34,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "master_gain_L",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1350,
						205,
						69,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.30"
				}
			},
			{
				"box": {
					"id": "master_gain_R",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1430,
						205,
						69,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.30"
				}
			},
			{
				"box": {
					"id": "clip_L",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						1350,
						240,
						104,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "clip~ -1. 1."
				}
			},
			{
				"box": {
					"id": "clip_R",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						1430,
						240,
						104,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "clip~ -1. 1."
				}
			},
			{
				"box": {
					"id": "dac",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 0,
					"patching_rect": [
						1380,
						280,
						40,
						22
					],
					"outlettype": [],
					"text": "dac~"
				}
			},
			{
				"box": {
					"id": "meter_L",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1350,
						320,
						60,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "meter~"
				}
			},
			{
				"box": {
					"id": "meter_R",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1430,
						320,
						60,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "meter~"
				}
			},
			{
				"box": {
					"id": "lbl_init",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						50,
						520,
						100,
						22
					],
					"outlettype": [],
					"text": "=== INIT ==="
				}
			},
			{
				"box": {
					"id": "loadbang",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						50,
						550,
						76,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"id": "lb_delay",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						50,
						580,
						83,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "delay 500"
				}
			},
			{
				"box": {
					"id": "msg_startwindow",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						50,
						610,
						85,
						22
					],
					"outlettype": [
						""
					],
					"text": "startwindow"
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"destination": [
						"dry_gain",
						0
					],
					"source": [
						"adc",
						0
					],
					"order": 0
				}
			},
			{
				"patchline": {
					"destination": [
						"tapin",
						0
					],
					"source": [
						"adc",
						0
					],
					"order": 1
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_rec",
						0
					],
					"source": [
						"adc",
						0
					],
					"order": 2
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_init_delay",
						0
					],
					"source": [
						"start_btn",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_rec_loop",
						0
					],
					"source": [
						"rev_init_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_rec_on",
						0
					],
					"source": [
						"rev_init_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_grv_loop",
						0
					],
					"source": [
						"rev_init_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_grv_rate",
						0
					],
					"source": [
						"rev_init_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_grv_on",
						0
					],
					"source": [
						"rev_init_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_rec",
						0
					],
					"source": [
						"rev_rec_loop",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_rec",
						0
					],
					"source": [
						"rev_rec_on",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_groove",
						0
					],
					"source": [
						"rev_grv_loop",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_groove",
						0
					],
					"source": [
						"rev_grv_rate",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_groove",
						0
					],
					"source": [
						"rev_grv_on",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_start",
						0
					],
					"source": [
						"start_btn",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_stop",
						0
					],
					"source": [
						"reset_btn",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"metro",
						0
					],
					"source": [
						"msg_start",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"metro",
						0
					],
					"source": [
						"msg_stop",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"counter",
						3
					],
					"source": [
						"msg_stop",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"counter",
						0
					],
					"source": [
						"metro",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"ticks_to_ms",
						0
					],
					"source": [
						"counter",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"ms_to_sec",
						0
					],
					"source": [
						"ticks_to_ms",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"time_display",
						0
					],
					"source": [
						"ms_to_sec",
						0
					],
					"order": 0
				}
			},
			{
				"patchline": {
					"destination": [
						"sec_to_min",
						0
					],
					"source": [
						"ms_to_sec",
						0
					],
					"order": 1
				}
			},
			{
				"patchline": {
					"destination": [
						"evo_sub",
						0
					],
					"source": [
						"ms_to_sec",
						0
					],
					"order": 2
				}
			},
			{
				"patchline": {
					"destination": [
						"onset_div",
						0
					],
					"source": [
						"ms_to_sec",
						0
					],
					"order": 3
				}
			},
			{
				"patchline": {
					"destination": [
						"chaos_expr",
						0
					],
					"source": [
						"ms_to_sec",
						0
					],
					"order": 4
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_sub",
						0
					],
					"source": [
						"ms_to_sec",
						0
					],
					"order": 5
				}
			},
			{
				"patchline": {
					"destination": [
						"min_display",
						0
					],
					"source": [
						"sec_to_min",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"evo_div",
						0
					],
					"source": [
						"evo_sub",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"evo_clip",
						0
					],
					"source": [
						"evo_div",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"onset_clip",
						0
					],
					"source": [
						"onset_div",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"chaos_sig",
						0
					],
					"source": [
						"chaos_expr",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_div",
						0
					],
					"source": [
						"rev_sub",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_clip",
						0
					],
					"source": [
						"rev_div",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_sig",
						0
					],
					"source": [
						"rev_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_expr_1",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_expr_1",
						1
					],
					"source": [
						"chaos_expr",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_pack_1",
						0
					],
					"source": [
						"fs_expr_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_line_1",
						0
					],
					"source": [
						"fs_pack_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_expr_1",
						0
					],
					"source": [
						"onset_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_pack_1",
						0
					],
					"source": [
						"vol_expr_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_line_1",
						0
					],
					"source": [
						"vol_pack_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_val_1",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"evo_sig_1",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"inv_evo_1",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"inv_sig_1",
						0
					],
					"source": [
						"inv_evo_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_a_scale_1",
						0
					],
					"source": [
						"swell_a_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_a_bias_1",
						0
					],
					"source": [
						"swell_a_scale_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_b_scale_1",
						0
					],
					"source": [
						"swell_b_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_b_bias_1",
						0
					],
					"source": [
						"swell_b_scale_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_prod_1",
						0
					],
					"source": [
						"swell_a_bias_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_prod_1",
						1
					],
					"source": [
						"swell_b_bias_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"breath_scale_1",
						0
					],
					"source": [
						"breath_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"breath_bias_1",
						0
					],
					"source": [
						"breath_scale_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_env_1",
						0
					],
					"source": [
						"swell_prod_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_env_1",
						1
					],
					"source": [
						"breath_bias_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_cm_1",
						0
					],
					"source": [
						"wobble_osc_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_cm_1",
						1
					],
					"source": [
						"chaos_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_d_1",
						0
					],
					"source": [
						"wobble_cm_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_sum_1",
						1
					],
					"source": [
						"wobble_d_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_scale_1",
						0
					],
					"source": [
						"rev_gate_osc_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_bias_1",
						0
					],
					"source": [
						"rev_gate_scale_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_sig_1",
						0
					],
					"source": [
						"rev_gate_bias_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_sig_1",
						1
					],
					"source": [
						"rev_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_expr_2",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_expr_2",
						1
					],
					"source": [
						"chaos_expr",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_pack_2",
						0
					],
					"source": [
						"fs_expr_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_line_2",
						0
					],
					"source": [
						"fs_pack_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_expr_2",
						0
					],
					"source": [
						"onset_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_pack_2",
						0
					],
					"source": [
						"vol_expr_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_line_2",
						0
					],
					"source": [
						"vol_pack_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_val_2",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"evo_sig_2",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"inv_evo_2",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"inv_sig_2",
						0
					],
					"source": [
						"inv_evo_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_a_scale_2",
						0
					],
					"source": [
						"swell_a_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_a_bias_2",
						0
					],
					"source": [
						"swell_a_scale_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_b_scale_2",
						0
					],
					"source": [
						"swell_b_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_b_bias_2",
						0
					],
					"source": [
						"swell_b_scale_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_prod_2",
						0
					],
					"source": [
						"swell_a_bias_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_prod_2",
						1
					],
					"source": [
						"swell_b_bias_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"breath_scale_2",
						0
					],
					"source": [
						"breath_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"breath_bias_2",
						0
					],
					"source": [
						"breath_scale_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_env_2",
						0
					],
					"source": [
						"swell_prod_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_env_2",
						1
					],
					"source": [
						"breath_bias_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_cm_2",
						0
					],
					"source": [
						"wobble_osc_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_cm_2",
						1
					],
					"source": [
						"chaos_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_d_2",
						0
					],
					"source": [
						"wobble_cm_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_sum_2",
						1
					],
					"source": [
						"wobble_d_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_scale_2",
						0
					],
					"source": [
						"rev_gate_osc_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_bias_2",
						0
					],
					"source": [
						"rev_gate_scale_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_sig_2",
						0
					],
					"source": [
						"rev_gate_bias_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_sig_2",
						1
					],
					"source": [
						"rev_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_expr_3",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_expr_3",
						1
					],
					"source": [
						"chaos_expr",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_pack_3",
						0
					],
					"source": [
						"fs_expr_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_line_3",
						0
					],
					"source": [
						"fs_pack_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_expr_3",
						0
					],
					"source": [
						"onset_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_pack_3",
						0
					],
					"source": [
						"vol_expr_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_line_3",
						0
					],
					"source": [
						"vol_pack_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_val_3",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"evo_sig_3",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"inv_evo_3",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"inv_sig_3",
						0
					],
					"source": [
						"inv_evo_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_a_scale_3",
						0
					],
					"source": [
						"swell_a_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_a_bias_3",
						0
					],
					"source": [
						"swell_a_scale_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_b_scale_3",
						0
					],
					"source": [
						"swell_b_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_b_bias_3",
						0
					],
					"source": [
						"swell_b_scale_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_prod_3",
						0
					],
					"source": [
						"swell_a_bias_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_prod_3",
						1
					],
					"source": [
						"swell_b_bias_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"breath_scale_3",
						0
					],
					"source": [
						"breath_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"breath_bias_3",
						0
					],
					"source": [
						"breath_scale_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_env_3",
						0
					],
					"source": [
						"swell_prod_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_env_3",
						1
					],
					"source": [
						"breath_bias_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_cm_3",
						0
					],
					"source": [
						"wobble_osc_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_cm_3",
						1
					],
					"source": [
						"chaos_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_d_3",
						0
					],
					"source": [
						"wobble_cm_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_sum_3",
						1
					],
					"source": [
						"wobble_d_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_scale_3",
						0
					],
					"source": [
						"rev_gate_osc_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_bias_3",
						0
					],
					"source": [
						"rev_gate_scale_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_sig_3",
						0
					],
					"source": [
						"rev_gate_bias_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_sig_3",
						1
					],
					"source": [
						"rev_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_expr_4",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_expr_4",
						1
					],
					"source": [
						"chaos_expr",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_pack_4",
						0
					],
					"source": [
						"fs_expr_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_line_4",
						0
					],
					"source": [
						"fs_pack_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_expr_4",
						0
					],
					"source": [
						"onset_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_pack_4",
						0
					],
					"source": [
						"vol_expr_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_line_4",
						0
					],
					"source": [
						"vol_pack_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_val_4",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"evo_sig_4",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"inv_evo_4",
						0
					],
					"source": [
						"evo_clip",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"inv_sig_4",
						0
					],
					"source": [
						"inv_evo_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_a_scale_4",
						0
					],
					"source": [
						"swell_a_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_a_bias_4",
						0
					],
					"source": [
						"swell_a_scale_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_b_scale_4",
						0
					],
					"source": [
						"swell_b_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_b_bias_4",
						0
					],
					"source": [
						"swell_b_scale_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_prod_4",
						0
					],
					"source": [
						"swell_a_bias_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"swell_prod_4",
						1
					],
					"source": [
						"swell_b_bias_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"breath_scale_4",
						0
					],
					"source": [
						"breath_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"breath_bias_4",
						0
					],
					"source": [
						"breath_scale_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_env_4",
						0
					],
					"source": [
						"swell_prod_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_env_4",
						1
					],
					"source": [
						"breath_bias_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_cm_4",
						0
					],
					"source": [
						"wobble_osc_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_cm_4",
						1
					],
					"source": [
						"chaos_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_d_4",
						0
					],
					"source": [
						"wobble_cm_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_sum_4",
						1
					],
					"source": [
						"wobble_d_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_scale_4",
						0
					],
					"source": [
						"rev_gate_osc_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_bias_4",
						0
					],
					"source": [
						"rev_gate_scale_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_sig_4",
						0
					],
					"source": [
						"rev_gate_bias_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gate_sig_4",
						1
					],
					"source": [
						"rev_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"tapout_a_1",
						0
					],
					"source": [
						"tapin",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"tapout_b_1",
						0
					],
					"source": [
						"tapin",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_a_1",
						0
					],
					"source": [
						"tapout_a_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_a_1",
						1
					],
					"source": [
						"inv_sig_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_b_1",
						0
					],
					"source": [
						"tapout_b_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_b_1",
						1
					],
					"source": [
						"evo_sig_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_sum_1",
						0
					],
					"source": [
						"xf_a_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_sum_1",
						1
					],
					"source": [
						"xf_b_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"freqshift_1",
						0
					],
					"source": [
						"xf_sum_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_sum_1",
						0
					],
					"source": [
						"fs_line_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"freqshift_1",
						1
					],
					"source": [
						"wobble_sum_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_mult_1",
						0
					],
					"source": [
						"freqshift_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_mult_1",
						1
					],
					"source": [
						"vol_line_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_mult_1",
						0
					],
					"source": [
						"vol_mult_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_scale_1",
						0
					],
					"source": [
						"chaos_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_add_1",
						0
					],
					"source": [
						"sat_scale_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_mult_1",
						1
					],
					"source": [
						"sat_add_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_mult_1",
						0
					],
					"source": [
						"sat_mult_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_mult_1",
						1
					],
					"source": [
						"dyn_env_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gated_1",
						0
					],
					"source": [
						"rev_groove",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gated_1",
						1
					],
					"source": [
						"rev_gate_sig_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_scaled_1",
						0
					],
					"source": [
						"rev_gated_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_mix_1",
						1
					],
					"source": [
						"rev_scaled_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_mix_1",
						0
					],
					"source": [
						"dyn_mult_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_1",
						0
					],
					"source": [
						"rev_mix_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_1",
						1
					],
					"source": [
						"pan_val_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"tapout_a_2",
						0
					],
					"source": [
						"tapin",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"tapout_b_2",
						0
					],
					"source": [
						"tapin",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_a_2",
						0
					],
					"source": [
						"tapout_a_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_a_2",
						1
					],
					"source": [
						"inv_sig_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_b_2",
						0
					],
					"source": [
						"tapout_b_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_b_2",
						1
					],
					"source": [
						"evo_sig_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_sum_2",
						0
					],
					"source": [
						"xf_a_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_sum_2",
						1
					],
					"source": [
						"xf_b_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"freqshift_2",
						0
					],
					"source": [
						"xf_sum_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_sum_2",
						0
					],
					"source": [
						"fs_line_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"freqshift_2",
						1
					],
					"source": [
						"wobble_sum_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_mult_2",
						0
					],
					"source": [
						"freqshift_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_mult_2",
						1
					],
					"source": [
						"vol_line_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_mult_2",
						0
					],
					"source": [
						"vol_mult_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_scale_2",
						0
					],
					"source": [
						"chaos_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_add_2",
						0
					],
					"source": [
						"sat_scale_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_mult_2",
						1
					],
					"source": [
						"sat_add_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_mult_2",
						0
					],
					"source": [
						"sat_mult_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_mult_2",
						1
					],
					"source": [
						"dyn_env_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gated_2",
						0
					],
					"source": [
						"rev_groove",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gated_2",
						1
					],
					"source": [
						"rev_gate_sig_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_scaled_2",
						0
					],
					"source": [
						"rev_gated_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_mix_2",
						1
					],
					"source": [
						"rev_scaled_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_mix_2",
						0
					],
					"source": [
						"dyn_mult_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_2",
						0
					],
					"source": [
						"rev_mix_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_2",
						1
					],
					"source": [
						"pan_val_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"tapout_a_3",
						0
					],
					"source": [
						"tapin",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"tapout_b_3",
						0
					],
					"source": [
						"tapin",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_a_3",
						0
					],
					"source": [
						"tapout_a_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_a_3",
						1
					],
					"source": [
						"inv_sig_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_b_3",
						0
					],
					"source": [
						"tapout_b_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_b_3",
						1
					],
					"source": [
						"evo_sig_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_sum_3",
						0
					],
					"source": [
						"xf_a_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_sum_3",
						1
					],
					"source": [
						"xf_b_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"freqshift_3",
						0
					],
					"source": [
						"xf_sum_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_sum_3",
						0
					],
					"source": [
						"fs_line_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"freqshift_3",
						1
					],
					"source": [
						"wobble_sum_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_mult_3",
						0
					],
					"source": [
						"freqshift_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_mult_3",
						1
					],
					"source": [
						"vol_line_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_mult_3",
						0
					],
					"source": [
						"vol_mult_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_scale_3",
						0
					],
					"source": [
						"chaos_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_add_3",
						0
					],
					"source": [
						"sat_scale_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_mult_3",
						1
					],
					"source": [
						"sat_add_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_mult_3",
						0
					],
					"source": [
						"sat_mult_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_mult_3",
						1
					],
					"source": [
						"dyn_env_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gated_3",
						0
					],
					"source": [
						"rev_groove",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gated_3",
						1
					],
					"source": [
						"rev_gate_sig_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_scaled_3",
						0
					],
					"source": [
						"rev_gated_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_mix_3",
						1
					],
					"source": [
						"rev_scaled_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_mix_3",
						0
					],
					"source": [
						"dyn_mult_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_3",
						0
					],
					"source": [
						"rev_mix_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_3",
						1
					],
					"source": [
						"pan_val_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"tapout_a_4",
						0
					],
					"source": [
						"tapin",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"tapout_b_4",
						0
					],
					"source": [
						"tapin",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_a_4",
						0
					],
					"source": [
						"tapout_a_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_a_4",
						1
					],
					"source": [
						"inv_sig_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_b_4",
						0
					],
					"source": [
						"tapout_b_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_b_4",
						1
					],
					"source": [
						"evo_sig_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_sum_4",
						0
					],
					"source": [
						"xf_a_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"xf_sum_4",
						1
					],
					"source": [
						"xf_b_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"freqshift_4",
						0
					],
					"source": [
						"xf_sum_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_sum_4",
						0
					],
					"source": [
						"fs_line_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"freqshift_4",
						1
					],
					"source": [
						"wobble_sum_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_mult_4",
						0
					],
					"source": [
						"freqshift_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_mult_4",
						1
					],
					"source": [
						"vol_line_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_mult_4",
						0
					],
					"source": [
						"vol_mult_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_scale_4",
						0
					],
					"source": [
						"chaos_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_add_4",
						0
					],
					"source": [
						"sat_scale_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_mult_4",
						1
					],
					"source": [
						"sat_add_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_mult_4",
						0
					],
					"source": [
						"sat_mult_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dyn_mult_4",
						1
					],
					"source": [
						"dyn_env_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gated_4",
						0
					],
					"source": [
						"rev_groove",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_gated_4",
						1
					],
					"source": [
						"rev_gate_sig_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_scaled_4",
						0
					],
					"source": [
						"rev_gated_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_mix_4",
						1
					],
					"source": [
						"rev_scaled_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_mix_4",
						0
					],
					"source": [
						"dyn_mult_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_4",
						0
					],
					"source": [
						"rev_mix_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_4",
						1
					],
					"source": [
						"pan_val_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sum_L_12",
						0
					],
					"source": [
						"pan_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sum_R_12",
						0
					],
					"source": [
						"pan_1",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sum_L_12",
						1
					],
					"source": [
						"pan_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sum_R_12",
						1
					],
					"source": [
						"pan_2",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sum_L_34",
						0
					],
					"source": [
						"pan_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sum_R_34",
						0
					],
					"source": [
						"pan_3",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sum_L_34",
						1
					],
					"source": [
						"pan_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sum_R_34",
						1
					],
					"source": [
						"pan_4",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sum_L_all",
						0
					],
					"source": [
						"sum_L_12",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sum_L_all",
						1
					],
					"source": [
						"sum_L_34",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sum_R_all",
						0
					],
					"source": [
						"sum_R_12",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sum_R_all",
						1
					],
					"source": [
						"sum_R_34",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mix_L",
						0
					],
					"source": [
						"sum_L_all",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mix_R",
						0
					],
					"source": [
						"sum_R_all",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mix_L",
						1
					],
					"source": [
						"dry_gain",
						0
					],
					"order": 0
				}
			},
			{
				"patchline": {
					"destination": [
						"mix_R",
						1
					],
					"source": [
						"dry_gain",
						0
					],
					"order": 1
				}
			},
			{
				"patchline": {
					"destination": [
						"master_gain_L",
						0
					],
					"source": [
						"mix_L",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"master_gain_R",
						0
					],
					"source": [
						"mix_R",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"clip_L",
						0
					],
					"source": [
						"master_gain_L",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"clip_R",
						0
					],
					"source": [
						"master_gain_R",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dac",
						0
					],
					"source": [
						"clip_L",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dac",
						1
					],
					"source": [
						"clip_R",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"meter_L",
						0
					],
					"source": [
						"clip_L",
						0
					],
					"order": 0
				}
			},
			{
				"patchline": {
					"destination": [
						"meter_R",
						0
					],
					"source": [
						"clip_R",
						0
					],
					"order": 0
				}
			},
			{
				"patchline": {
					"destination": [
						"lb_delay",
						0
					],
					"source": [
						"loadbang",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_startwindow",
						0
					],
					"source": [
						"lb_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"dac",
						0
					],
					"source": [
						"msg_startwindow",
						0
					]
				}
			}
		],
		"dependency_cache": [
			{
				"name": "pan2.maxpat",
				"bootpath": "~/Library/Application Support/Cycling '74/Max 9/Examples/spatialization/panning/lib",
				"patcherrelativepath": "../../../Library/Application Support/Cycling '74/Max 9/Examples/spatialization/panning/lib",
				"type": "JSON",
				"implicit": 1
			}
		],
		"autosave": 0
	}
}