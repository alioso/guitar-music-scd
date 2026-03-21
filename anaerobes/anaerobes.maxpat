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
					"text": "--- G1: pan=25.0, vol=1.4 ---"
				}
			},
			{
				"box": {
					"id": "fs_expr_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						500,
						65,
						200,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 1.0 + $f1 * 3.0"
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
					"text": "expr $f1 * 1.4"
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
					"text": "expr 25.0"
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
					"text": "--- G2: pan=-25.0, vol=1.4 ---"
				}
			},
			{
				"box": {
					"id": "fs_expr_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						500,
						265,
						200,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr -1.5 + $f1 * -3.5"
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
					"text": "expr $f1 * 1.4"
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
					"text": "expr -25.0"
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
					"text": "--- G3: pan=50.0, vol=1.3 ---"
				}
			},
			{
				"box": {
					"id": "fs_expr_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						500,
						465,
						200,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 2.0 + $f1 * 4.0"
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
					"text": "expr $f1 * 1.3"
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
					"text": "expr 50.0"
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
					"text": "--- G4: pan=-50.0, vol=1.3 ---"
				}
			},
			{
				"box": {
					"id": "fs_expr_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						500,
						665,
						200,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr -2.5 + $f1 * -4.5"
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
					"text": "expr $f1 * 1.3"
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
					"text": "expr -50.0"
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
					"id": "pan_1",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						750,
						300,
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
					"id": "pan_2",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						930,
						300,
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
					"id": "pan_3",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						1110,
						300,
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
					"id": "pan_4",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						1290,
						300,
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
					"text": "*~ 0.25"
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
					"text": "*~ 0.25"
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
						"freqshift_1",
						1
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
						"pan_1",
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
						"freqshift_2",
						1
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
						"pan_2",
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
						"freqshift_3",
						1
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
						"pan_3",
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
						"freqshift_4",
						1
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
						"pan_4",
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