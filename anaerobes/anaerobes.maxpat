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
					"text": "- 60."
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
					"text": "/ 420."
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
					"text": "--- G1: pan=25.0, vol=0.82 ---"
				}
			},
			{
				"box": {
					"id": "ph_sub_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						65,
						60,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "- 0.0"
				}
			},
			{
				"box": {
					"id": "ph_div_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						90,
						60,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 1.0"
				}
			},
			{
				"box": {
					"id": "ph_clip_1",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						500,
						115,
						75,
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
					"id": "risset_env_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						500,
						145,
						200,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 1. - abs(2. * $f1 - 1.)"
				}
			},
			{
				"box": {
					"id": "delay_expr_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						180,
						220,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 12.0 + $f1 * $f2 * 1488.0"
				}
			},
			{
				"box": {
					"id": "delay_pack_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						210,
						90,
						22
					],
					"outlettype": [
						""
					],
					"text": "pack 0. 2000"
				}
			},
			{
				"box": {
					"id": "delay_line_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						240,
						95,
						22
					],
					"outlettype": [
						""
					],
					"text": "line 12.0 2000"
				}
			},
			{
				"box": {
					"id": "vol_expr_1",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						730,
						180,
						250,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr $f3 * (0.82 - 0.25 * $f1 * $f2)"
				}
			},
			{
				"box": {
					"id": "vol_pack_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						730,
						210,
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
						730,
						240,
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
					"id": "fs_expr_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						730,
						65,
						180,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 0.3 + $f1 * 0.8999999999999999"
				}
			},
			{
				"box": {
					"id": "fs_pack_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						730,
						90,
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
						730,
						115,
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
					"id": "pan_expr_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						920,
						65,
						160,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 25.0 + $f1 * 5.0"
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
						290,
						250,
						22
					],
					"outlettype": [],
					"text": "--- G2: pan=-25.0, vol=0.78 ---"
				}
			},
			{
				"box": {
					"id": "ph_sub_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						315,
						60,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "- 0.15"
				}
			},
			{
				"box": {
					"id": "ph_div_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						340,
						60,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 0.85"
				}
			},
			{
				"box": {
					"id": "ph_clip_2",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						500,
						365,
						75,
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
					"id": "risset_env_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						500,
						395,
						200,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 1. - abs(2. * $f1 - 1.)"
				}
			},
			{
				"box": {
					"id": "delay_expr_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						430,
						220,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 23.0 + $f1 * $f2 * 2777.0"
				}
			},
			{
				"box": {
					"id": "delay_pack_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						460,
						90,
						22
					],
					"outlettype": [
						""
					],
					"text": "pack 0. 2000"
				}
			},
			{
				"box": {
					"id": "delay_line_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						490,
						95,
						22
					],
					"outlettype": [
						""
					],
					"text": "line 23.0 2000"
				}
			},
			{
				"box": {
					"id": "vol_expr_2",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						730,
						430,
						250,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr $f3 * (0.78 - 0.25 * $f1 * $f2)"
				}
			},
			{
				"box": {
					"id": "vol_pack_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						730,
						460,
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
						730,
						490,
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
					"id": "fs_expr_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						730,
						315,
						180,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr -0.5 + $f1 * -1.0"
				}
			},
			{
				"box": {
					"id": "fs_pack_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						730,
						340,
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
						730,
						365,
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
					"id": "pan_expr_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						920,
						315,
						160,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr -25.0 + $f1 * -5.0"
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
						540,
						250,
						22
					],
					"outlettype": [],
					"text": "--- G3: pan=50.0, vol=0.72 ---"
				}
			},
			{
				"box": {
					"id": "ph_sub_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						565,
						60,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "- 0.35"
				}
			},
			{
				"box": {
					"id": "ph_div_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						590,
						60,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 0.7"
				}
			},
			{
				"box": {
					"id": "ph_clip_3",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						500,
						615,
						75,
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
					"id": "risset_env_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						500,
						645,
						200,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 1. - abs(2. * $f1 - 1.)"
				}
			},
			{
				"box": {
					"id": "delay_expr_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						680,
						220,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 37.0 + $f1 * $f2 * 4163.0"
				}
			},
			{
				"box": {
					"id": "delay_pack_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						710,
						90,
						22
					],
					"outlettype": [
						""
					],
					"text": "pack 0. 2000"
				}
			},
			{
				"box": {
					"id": "delay_line_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						740,
						95,
						22
					],
					"outlettype": [
						""
					],
					"text": "line 37.0 2000"
				}
			},
			{
				"box": {
					"id": "vol_expr_3",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						730,
						680,
						250,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr $f3 * (0.72 - 0.25 * $f1 * $f2)"
				}
			},
			{
				"box": {
					"id": "vol_pack_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						730,
						710,
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
						730,
						740,
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
					"id": "fs_expr_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						730,
						565,
						180,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 0.7 + $f1 * 1.1"
				}
			},
			{
				"box": {
					"id": "fs_pack_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						730,
						590,
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
						730,
						615,
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
					"id": "pan_expr_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						920,
						565,
						160,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 50.0 + $f1 * 10.0"
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
						790,
						250,
						22
					],
					"outlettype": [],
					"text": "--- G4: pan=-50.0, vol=0.68 ---"
				}
			},
			{
				"box": {
					"id": "ph_sub_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						815,
						60,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "- 0.55"
				}
			},
			{
				"box": {
					"id": "ph_div_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						840,
						60,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 0.55"
				}
			},
			{
				"box": {
					"id": "ph_clip_4",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						500,
						865,
						75,
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
					"id": "risset_env_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						500,
						895,
						200,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 1. - abs(2. * $f1 - 1.)"
				}
			},
			{
				"box": {
					"id": "delay_expr_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						930,
						220,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr 48.0 + $f1 * $f2 * 5452.0"
				}
			},
			{
				"box": {
					"id": "delay_pack_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						960,
						90,
						22
					],
					"outlettype": [
						""
					],
					"text": "pack 0. 2000"
				}
			},
			{
				"box": {
					"id": "delay_line_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						500,
						990,
						95,
						22
					],
					"outlettype": [
						""
					],
					"text": "line 48.0 2000"
				}
			},
			{
				"box": {
					"id": "vol_expr_4",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						730,
						930,
						250,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr $f3 * (0.68 - 0.25 * $f1 * $f2)"
				}
			},
			{
				"box": {
					"id": "vol_pack_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						730,
						960,
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
						730,
						990,
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
					"id": "fs_expr_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						730,
						815,
						180,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr -0.8 + $f1 * -1.2"
				}
			},
			{
				"box": {
					"id": "fs_pack_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						730,
						840,
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
						730,
						865,
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
					"id": "pan_expr_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						920,
						815,
						160,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr -50.0 + $f1 * -10.0"
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
					"id": "tapout_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						750,
						70,
						90,
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
					"id": "freqshift_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						750,
						110,
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
						150,
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
						190,
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
						920,
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
					"id": "tapout_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						900,
						70,
						90,
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
					"id": "freqshift_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						900,
						110,
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
						900,
						150,
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
						900,
						190,
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
						1070,
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
					"id": "tapout_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1050,
						70,
						90,
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
					"id": "freqshift_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1050,
						110,
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
						1050,
						150,
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
						1050,
						190,
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
						1220,
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
					"id": "tapout_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1200,
						70,
						90,
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
					"id": "freqshift_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1200,
						110,
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
						1200,
						150,
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
						1200,
						190,
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
						62,
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
					"id": "master_gain_R",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1430,
						205,
						62,
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
						"ph_sub_1",
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
						"ph_div_1",
						0
					],
					"source": [
						"ph_sub_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"ph_clip_1",
						0
					],
					"source": [
						"ph_div_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"risset_env_1",
						0
					],
					"source": [
						"ph_clip_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"delay_expr_1",
						0
					],
					"source": [
						"risset_env_1",
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
						"risset_env_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"delay_expr_1",
						1
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
						"vol_expr_1",
						1
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
						"pan_expr_1",
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
						"vol_expr_1",
						2
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
						"delay_pack_1",
						0
					],
					"source": [
						"delay_expr_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"delay_line_1",
						0
					],
					"source": [
						"delay_pack_1",
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
						"ph_sub_2",
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
						"ph_div_2",
						0
					],
					"source": [
						"ph_sub_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"ph_clip_2",
						0
					],
					"source": [
						"ph_div_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"risset_env_2",
						0
					],
					"source": [
						"ph_clip_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"delay_expr_2",
						0
					],
					"source": [
						"risset_env_2",
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
						"risset_env_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"delay_expr_2",
						1
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
						"vol_expr_2",
						1
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
						"pan_expr_2",
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
						"vol_expr_2",
						2
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
						"delay_pack_2",
						0
					],
					"source": [
						"delay_expr_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"delay_line_2",
						0
					],
					"source": [
						"delay_pack_2",
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
						"ph_sub_3",
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
						"ph_div_3",
						0
					],
					"source": [
						"ph_sub_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"ph_clip_3",
						0
					],
					"source": [
						"ph_div_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"risset_env_3",
						0
					],
					"source": [
						"ph_clip_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"delay_expr_3",
						0
					],
					"source": [
						"risset_env_3",
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
						"risset_env_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"delay_expr_3",
						1
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
						"vol_expr_3",
						1
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
						"pan_expr_3",
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
						"vol_expr_3",
						2
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
						"delay_pack_3",
						0
					],
					"source": [
						"delay_expr_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"delay_line_3",
						0
					],
					"source": [
						"delay_pack_3",
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
						"ph_sub_4",
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
						"ph_div_4",
						0
					],
					"source": [
						"ph_sub_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"ph_clip_4",
						0
					],
					"source": [
						"ph_div_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"risset_env_4",
						0
					],
					"source": [
						"ph_clip_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"delay_expr_4",
						0
					],
					"source": [
						"risset_env_4",
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
						"risset_env_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"delay_expr_4",
						1
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
						"vol_expr_4",
						1
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
						"pan_expr_4",
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
						"vol_expr_4",
						2
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
						"delay_pack_4",
						0
					],
					"source": [
						"delay_expr_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"delay_line_4",
						0
					],
					"source": [
						"delay_pack_4",
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
						"tapout_1",
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
						"tapout_1",
						0
					],
					"source": [
						"delay_line_1",
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
						"tapout_1",
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
						"pan_expr_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"tapout_2",
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
						"tapout_2",
						0
					],
					"source": [
						"delay_line_2",
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
						"tapout_2",
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
						"pan_expr_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"tapout_3",
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
						"tapout_3",
						0
					],
					"source": [
						"delay_line_3",
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
						"tapout_3",
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
						"pan_expr_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"tapout_4",
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
						"tapout_4",
						0
					],
					"source": [
						"delay_line_4",
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
						"tapout_4",
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
						"pan_expr_4",
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