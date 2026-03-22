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
			0,
			0,
			2200,
			1300
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
						40,
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
						220,
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
						280,
						44,
						180,
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
						40,
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
						40,
						120,
						62,
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
					"id": "lbl_dry",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						110,
						122,
						150,
						22
					],
					"outlettype": [],
					"text": "dry guitar (center)"
				}
			},
			{
				"box": {
					"id": "loadbang",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						260,
						80,
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
						260,
						110,
						83,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "delay 300"
				}
			},
			{
				"box": {
					"id": "msg_startwindow",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						260,
						140,
						91,
						22
					],
					"outlettype": [
						""
					],
					"text": "startwindow"
				}
			},
			{
				"box": {
					"id": "lbl_timer",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						300,
						20,
						220,
						22
					],
					"outlettype": [],
					"text": "=== TIMER (480s = 8min) ==="
				}
			},
			{
				"box": {
					"id": "start_btn",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						300,
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
						330,
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
						380,
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
						410,
						44,
						90,
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
						300,
						75,
						21,
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
						380,
						75,
						21,
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
						300,
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
						300,
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
					"id": "ticks_ms",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						300,
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
						300,
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
						300,
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
					"id": "lbl_sec",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						375,
						237,
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
						440,
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
						440,
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
					"id": "lbl_min",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						505,
						267,
						60,
						22
					],
					"outlettype": [],
					"text": "minutes"
				}
			},
			{
				"box": {
					"id": "chaos_expr",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						300,
						400,
						510,
						22
					],
					"outlettype": [
						""
					],
					"text": "expr max(0., min(1., ($f1-120.)/165.)) * (1. - max(0., min(1., ($f1-285.)/135.)))"
				}
			},
			{
				"box": {
					"id": "chaos_sig",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						300,
						430,
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
						820,
						402,
						180,
						22
					],
					"outlettype": [],
					"text": "chaos 0..1 (peaks 4:45)"
				}
			},
			{
				"box": {
					"id": "rev_sub",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						480,
						300,
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
						480,
						330,
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
						480,
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
					"id": "rev_sig",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						480,
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
					"id": "lbl_rev",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						540,
						362,
						160,
						22
					],
					"outlettype": [],
					"text": "reverse arc (t>6min)"
				}
			},
			{
				"box": {
					"id": "lbl_ctrl",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						600,
						20,
						230,
						22
					],
					"outlettype": [],
					"text": "=== PER-VOICE MODULATION ==="
				}
			},
			{
				"box": {
					"id": "lbl_c1",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						650,
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
					"id": "lbl_rate1",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						600,
						58,
						35,
						22
					],
					"outlettype": [],
					"text": "rate"
				}
			},
			{
				"box": {
					"id": "drift_osc_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						600,
						75,
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
					"id": "drift_cx_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						600,
						105,
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
					"id": "drift_amp_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						600,
						135,
						75,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.025"
				}
			},
			{
				"box": {
					"id": "base_rate_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						600,
						165,
						60,
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
					"id": "rev_osc_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						685,
						75,
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
					"id": "rev_osc_scale_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						685,
						105,
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
					"id": "rev_osc_bias_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						685,
						135,
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
					"id": "rev_gated_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						685,
						165,
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
					"id": "rev_flip_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						685,
						195,
						65,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ -2.0"
				}
			},
			{
				"box": {
					"id": "rate_sig_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						640,
						225,
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
					"id": "lbl_fs1",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						600,
						255,
						70,
						22
					],
					"outlettype": [],
					"text": "freqshift"
				}
			},
			{
				"box": {
					"id": "fs_chaos_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						600,
						275,
						80,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 2.7"
				}
			},
			{
				"box": {
					"id": "fs_base_s_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						600,
						305,
						70,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.3"
				}
			},
			{
				"box": {
					"id": "wobble_osc_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						685,
						275,
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
					"id": "wobble_cx_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						685,
						305,
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
					"id": "wobble_hz_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						685,
						335,
						75,
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
					"id": "fs_sig_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						640,
						365,
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
					"id": "lbl_sw1",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						600,
						395,
						40,
						22
					],
					"outlettype": [],
					"text": "swell"
				}
			},
			{
				"box": {
					"id": "swell_a_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						600,
						415,
						90,
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
						600,
						445,
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
					"id": "swell_a_bias_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						600,
						475,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.6"
				}
			},
			{
				"box": {
					"id": "swell_b_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						685,
						415,
						90,
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
						685,
						445,
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
					"id": "swell_b_bias_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						685,
						475,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.6"
				}
			},
			{
				"box": {
					"id": "swell_prod_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						640,
						505,
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
						600,
						535,
						90,
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
						600,
						565,
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
						600,
						595,
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
						640,
						625,
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
					"id": "lbl_c2",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						810,
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
					"id": "lbl_rate2",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						760,
						58,
						35,
						22
					],
					"outlettype": [],
					"text": "rate"
				}
			},
			{
				"box": {
					"id": "drift_osc_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						760,
						75,
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
					"id": "drift_cx_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						760,
						105,
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
					"id": "drift_amp_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						760,
						135,
						75,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.02"
				}
			},
			{
				"box": {
					"id": "base_rate_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						760,
						165,
						60,
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
					"id": "rev_osc_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						845,
						75,
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
					"id": "rev_osc_scale_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						845,
						105,
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
					"id": "rev_osc_bias_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						845,
						135,
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
					"id": "rev_gated_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						845,
						165,
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
					"id": "rev_flip_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						845,
						195,
						65,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ -2.0"
				}
			},
			{
				"box": {
					"id": "rate_sig_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						800,
						225,
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
					"id": "lbl_fs2",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						760,
						255,
						70,
						22
					],
					"outlettype": [],
					"text": "freqshift"
				}
			},
			{
				"box": {
					"id": "fs_chaos_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						760,
						275,
						80,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ -4.1"
				}
			},
			{
				"box": {
					"id": "fs_base_s_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						760,
						305,
						70,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ -0.4"
				}
			},
			{
				"box": {
					"id": "wobble_osc_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						845,
						275,
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
					"id": "wobble_cx_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						845,
						305,
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
					"id": "wobble_hz_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						845,
						335,
						75,
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
					"id": "fs_sig_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						800,
						365,
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
					"id": "lbl_sw2",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						760,
						395,
						40,
						22
					],
					"outlettype": [],
					"text": "swell"
				}
			},
			{
				"box": {
					"id": "swell_a_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						760,
						415,
						90,
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
						760,
						445,
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
					"id": "swell_a_bias_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						760,
						475,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.6"
				}
			},
			{
				"box": {
					"id": "swell_b_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						845,
						415,
						90,
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
						845,
						445,
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
					"id": "swell_b_bias_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						845,
						475,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.6"
				}
			},
			{
				"box": {
					"id": "swell_prod_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						800,
						505,
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
						760,
						535,
						90,
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
						760,
						565,
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
						760,
						595,
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
						800,
						625,
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
					"id": "lbl_c3",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						970,
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
					"id": "lbl_rate3",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						920,
						58,
						35,
						22
					],
					"outlettype": [],
					"text": "rate"
				}
			},
			{
				"box": {
					"id": "drift_osc_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						920,
						75,
						90,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.033"
				}
			},
			{
				"box": {
					"id": "drift_cx_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						920,
						105,
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
					"id": "drift_amp_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						920,
						135,
						75,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.032"
				}
			},
			{
				"box": {
					"id": "base_rate_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						920,
						165,
						60,
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
					"id": "rev_osc_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1005,
						75,
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
					"id": "rev_osc_scale_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1005,
						105,
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
					"id": "rev_osc_bias_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1005,
						135,
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
					"id": "rev_gated_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1005,
						165,
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
					"id": "rev_flip_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1005,
						195,
						65,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ -2.0"
				}
			},
			{
				"box": {
					"id": "rate_sig_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						960,
						225,
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
					"id": "lbl_fs3",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						920,
						255,
						70,
						22
					],
					"outlettype": [],
					"text": "freqshift"
				}
			},
			{
				"box": {
					"id": "fs_chaos_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						920,
						275,
						80,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 5.0"
				}
			},
			{
				"box": {
					"id": "fs_base_s_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						920,
						305,
						70,
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
					"id": "wobble_osc_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1005,
						275,
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
					"id": "wobble_cx_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1005,
						305,
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
					"id": "wobble_hz_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1005,
						335,
						75,
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
					"id": "fs_sig_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						960,
						365,
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
					"id": "lbl_sw3",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						920,
						395,
						40,
						22
					],
					"outlettype": [],
					"text": "swell"
				}
			},
			{
				"box": {
					"id": "swell_a_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						920,
						415,
						90,
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
						920,
						445,
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
					"id": "swell_a_bias_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						920,
						475,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.6"
				}
			},
			{
				"box": {
					"id": "swell_b_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1005,
						415,
						90,
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
						1005,
						445,
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
					"id": "swell_b_bias_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1005,
						475,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.6"
				}
			},
			{
				"box": {
					"id": "swell_prod_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						960,
						505,
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
						920,
						535,
						90,
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
						920,
						565,
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
						920,
						595,
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
						960,
						625,
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
					"id": "lbl_c4",
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
					"text": "G4"
				}
			},
			{
				"box": {
					"id": "lbl_rate4",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1080,
						58,
						35,
						22
					],
					"outlettype": [],
					"text": "rate"
				}
			},
			{
				"box": {
					"id": "drift_osc_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1080,
						75,
						90,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 0.041"
				}
			},
			{
				"box": {
					"id": "drift_cx_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1080,
						105,
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
					"id": "drift_amp_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1080,
						135,
						75,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.038"
				}
			},
			{
				"box": {
					"id": "base_rate_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1080,
						165,
						60,
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
					"id": "rev_osc_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1165,
						75,
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
					"id": "rev_osc_scale_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1165,
						105,
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
					"id": "rev_osc_bias_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1165,
						135,
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
					"id": "rev_gated_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1165,
						165,
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
					"id": "rev_flip_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1165,
						195,
						65,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ -2.0"
				}
			},
			{
				"box": {
					"id": "rate_sig_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1120,
						225,
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
					"id": "lbl_fs4",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1080,
						255,
						70,
						22
					],
					"outlettype": [],
					"text": "freqshift"
				}
			},
			{
				"box": {
					"id": "fs_chaos_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1080,
						275,
						80,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ -5.9"
				}
			},
			{
				"box": {
					"id": "fs_base_s_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1080,
						305,
						70,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ -0.6"
				}
			},
			{
				"box": {
					"id": "wobble_osc_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1165,
						275,
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
					"id": "wobble_cx_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1165,
						305,
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
					"id": "wobble_hz_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1165,
						335,
						75,
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
					"id": "fs_sig_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1120,
						365,
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
					"id": "lbl_sw4",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1080,
						395,
						40,
						22
					],
					"outlettype": [],
					"text": "swell"
				}
			},
			{
				"box": {
					"id": "swell_a_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1080,
						415,
						90,
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
						1080,
						445,
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
					"id": "swell_a_bias_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1080,
						475,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.6"
				}
			},
			{
				"box": {
					"id": "swell_b_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1165,
						415,
						90,
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
						1165,
						445,
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
					"id": "swell_b_bias_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1165,
						475,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0.6"
				}
			},
			{
				"box": {
					"id": "swell_prod_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1120,
						505,
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
						1080,
						535,
						90,
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
						1080,
						565,
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
						1080,
						595,
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
						1120,
						625,
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
						1250,
						20,
						150,
						22
					],
					"outlettype": [],
					"text": "=== VOICE AUDIO ==="
				}
			},
			{
				"box": {
					"id": "rec_delay",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1250,
						40,
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
					"id": "rec_on_msg",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1330,
						40,
						20,
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
					"id": "grv_on_msg",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1360,
						40,
						65,
						22
					],
					"outlettype": [
						""
					],
					"text": "startloop"
				}
			},
			{
				"box": {
					"id": "rec_loop_msg",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1330,
						70,
						60,
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
					"id": "lbl_a1",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1330,
						100,
						40,
						22
					],
					"outlettype": [],
					"text": "G1"
				}
			},
			{
				"box": {
					"id": "buf_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1250,
						125,
						140,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "buffer~ v1_buf 4700"
				}
			},
			{
				"box": {
					"id": "rec_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1250,
						160,
						110,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "record~ v1_buf"
				}
			},
			{
				"box": {
					"id": "grv_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1250,
						200,
						150,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "groove~ v1_buf 1 @loop 1"
				}
			},
			{
				"box": {
					"id": "fs_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1250,
						245,
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
					"id": "sat_boost_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1305,
						285,
						80,
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
						1305,
						315,
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
					"id": "sat_mult_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1250,
						315,
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
					"id": "vclip_1",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						1250,
						350,
						85,
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
					"id": "dyn_mult_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1250,
						390,
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
					"id": "pan_1",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						1250,
						430,
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
					"id": "pan_msg_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1310,
						430,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "0.66"
				}
			},
			{
				"box": {
					"id": "lbl_a2",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1525,
						100,
						40,
						22
					],
					"outlettype": [],
					"text": "G2"
				}
			},
			{
				"box": {
					"id": "buf_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1445,
						125,
						140,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "buffer~ v2_buf 7300"
				}
			},
			{
				"box": {
					"id": "rec_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1445,
						160,
						110,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "record~ v2_buf"
				}
			},
			{
				"box": {
					"id": "grv_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1445,
						200,
						150,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "groove~ v2_buf 1 @loop 1"
				}
			},
			{
				"box": {
					"id": "fs_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1445,
						245,
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
					"id": "sat_boost_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1500,
						285,
						80,
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
						1500,
						315,
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
					"id": "sat_mult_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1445,
						315,
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
					"id": "vclip_2",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						1445,
						350,
						85,
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
					"id": "dyn_mult_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1445,
						390,
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
					"id": "pan_2",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						1445,
						430,
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
					"id": "pan_msg_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1505,
						430,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "0.36"
				}
			},
			{
				"box": {
					"id": "lbl_a3",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1720,
						100,
						40,
						22
					],
					"outlettype": [],
					"text": "G3"
				}
			},
			{
				"box": {
					"id": "buf_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1640,
						125,
						140,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "buffer~ v3_buf 11100"
				}
			},
			{
				"box": {
					"id": "rec_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1640,
						160,
						110,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "record~ v3_buf"
				}
			},
			{
				"box": {
					"id": "grv_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1640,
						200,
						150,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "groove~ v3_buf 1 @loop 1"
				}
			},
			{
				"box": {
					"id": "fs_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1640,
						245,
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
					"id": "sat_boost_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1695,
						285,
						80,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 2.0"
				}
			},
			{
				"box": {
					"id": "sat_add_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1695,
						315,
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
					"id": "sat_mult_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1640,
						315,
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
					"id": "vclip_3",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						1640,
						350,
						85,
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
					"id": "dyn_mult_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1640,
						390,
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
					"id": "pan_3",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						1640,
						430,
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
					"id": "pan_msg_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1700,
						430,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "0.89"
				}
			},
			{
				"box": {
					"id": "lbl_a4",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1915,
						100,
						40,
						22
					],
					"outlettype": [],
					"text": "G4"
				}
			},
			{
				"box": {
					"id": "buf_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1835,
						125,
						140,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "buffer~ v4_buf 13900"
				}
			},
			{
				"box": {
					"id": "rec_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1835,
						160,
						110,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "record~ v4_buf"
				}
			},
			{
				"box": {
					"id": "grv_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1835,
						200,
						150,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "groove~ v4_buf 1 @loop 1"
				}
			},
			{
				"box": {
					"id": "fs_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1835,
						245,
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
					"id": "sat_boost_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1890,
						285,
						80,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 2.0"
				}
			},
			{
				"box": {
					"id": "sat_add_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1890,
						315,
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
					"id": "sat_mult_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1835,
						315,
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
					"id": "vclip_4",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						1835,
						350,
						85,
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
					"id": "dyn_mult_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1835,
						390,
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
					"id": "pan_4",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						1835,
						430,
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
					"id": "pan_msg_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1895,
						430,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "0.13"
				}
			},
			{
				"box": {
					"id": "lbl_mix",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2050,
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
						2050,
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
						2050,
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
						2050,
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
						2130,
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
						2130,
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
						2130,
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
						2050,
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
						2130,
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
						2050,
						205,
						69,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.20"
				}
			},
			{
				"box": {
					"id": "master_gain_R",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2130,
						205,
						69,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.20"
				}
			},
			{
				"box": {
					"id": "clip_L",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						2050,
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
						2130,
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
						2080,
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
						2050,
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
						2130,
						320,
						60,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "meter~"
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
					]
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
						"ticks_ms",
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
						"ticks_ms",
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
						"chaos_expr",
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
						"rev_sub",
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
						"drift_cx_1",
						0
					],
					"source": [
						"drift_osc_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"drift_cx_1",
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
						"drift_amp_1",
						0
					],
					"source": [
						"drift_cx_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"base_rate_1",
						0
					],
					"source": [
						"drift_amp_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_osc_scale_1",
						0
					],
					"source": [
						"rev_osc_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_osc_bias_1",
						0
					],
					"source": [
						"rev_osc_scale_1",
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
						"rev_osc_bias_1",
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
						"rev_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_flip_1",
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
						"rate_sig_1",
						0
					],
					"source": [
						"base_rate_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_sig_1",
						1
					],
					"source": [
						"rev_flip_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_chaos_1",
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
						"fs_base_s_1",
						0
					],
					"source": [
						"fs_chaos_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_cx_1",
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
						"wobble_cx_1",
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
						"wobble_hz_1",
						0
					],
					"source": [
						"wobble_cx_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_sig_1",
						0
					],
					"source": [
						"fs_base_s_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_sig_1",
						1
					],
					"source": [
						"wobble_hz_1",
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
						"drift_cx_2",
						0
					],
					"source": [
						"drift_osc_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"drift_cx_2",
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
						"drift_amp_2",
						0
					],
					"source": [
						"drift_cx_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"base_rate_2",
						0
					],
					"source": [
						"drift_amp_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_osc_scale_2",
						0
					],
					"source": [
						"rev_osc_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_osc_bias_2",
						0
					],
					"source": [
						"rev_osc_scale_2",
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
						"rev_osc_bias_2",
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
						"rev_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_flip_2",
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
						"rate_sig_2",
						0
					],
					"source": [
						"base_rate_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_sig_2",
						1
					],
					"source": [
						"rev_flip_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_chaos_2",
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
						"fs_base_s_2",
						0
					],
					"source": [
						"fs_chaos_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_cx_2",
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
						"wobble_cx_2",
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
						"wobble_hz_2",
						0
					],
					"source": [
						"wobble_cx_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_sig_2",
						0
					],
					"source": [
						"fs_base_s_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_sig_2",
						1
					],
					"source": [
						"wobble_hz_2",
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
						"drift_cx_3",
						0
					],
					"source": [
						"drift_osc_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"drift_cx_3",
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
						"drift_amp_3",
						0
					],
					"source": [
						"drift_cx_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"base_rate_3",
						0
					],
					"source": [
						"drift_amp_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_osc_scale_3",
						0
					],
					"source": [
						"rev_osc_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_osc_bias_3",
						0
					],
					"source": [
						"rev_osc_scale_3",
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
						"rev_osc_bias_3",
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
						"rev_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_flip_3",
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
						"rate_sig_3",
						0
					],
					"source": [
						"base_rate_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_sig_3",
						1
					],
					"source": [
						"rev_flip_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_chaos_3",
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
						"fs_base_s_3",
						0
					],
					"source": [
						"fs_chaos_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_cx_3",
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
						"wobble_cx_3",
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
						"wobble_hz_3",
						0
					],
					"source": [
						"wobble_cx_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_sig_3",
						0
					],
					"source": [
						"fs_base_s_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_sig_3",
						1
					],
					"source": [
						"wobble_hz_3",
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
						"drift_cx_4",
						0
					],
					"source": [
						"drift_osc_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"drift_cx_4",
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
						"drift_amp_4",
						0
					],
					"source": [
						"drift_cx_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"base_rate_4",
						0
					],
					"source": [
						"drift_amp_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_osc_scale_4",
						0
					],
					"source": [
						"rev_osc_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_osc_bias_4",
						0
					],
					"source": [
						"rev_osc_scale_4",
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
						"rev_osc_bias_4",
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
						"rev_sig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rev_flip_4",
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
						"rate_sig_4",
						0
					],
					"source": [
						"base_rate_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_sig_4",
						1
					],
					"source": [
						"rev_flip_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_chaos_4",
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
						"fs_base_s_4",
						0
					],
					"source": [
						"fs_chaos_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"wobble_cx_4",
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
						"wobble_cx_4",
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
						"wobble_hz_4",
						0
					],
					"source": [
						"wobble_cx_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_sig_4",
						0
					],
					"source": [
						"fs_base_s_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_sig_4",
						1
					],
					"source": [
						"wobble_hz_4",
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
						"rec_delay",
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
						"grv_on_msg",
						0
					],
					"source": [
						"rec_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rec_loop_msg",
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
						"rec_on_msg",
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
						"rec_1",
						0
					],
					"source": [
						"adc",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rec_1",
						0
					],
					"source": [
						"rec_loop_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rec_1",
						0
					],
					"source": [
						"rec_on_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"grv_1",
						0
					],
					"source": [
						"grv_on_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"grv_1",
						0
					],
					"source": [
						"rate_sig_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_1",
						0
					],
					"source": [
						"grv_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_1",
						1
					],
					"source": [
						"fs_sig_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_boost_1",
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
						"sat_boost_1",
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
						"fs_1",
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
						"vclip_1",
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
						0
					],
					"source": [
						"vclip_1",
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
						"pan_1",
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
						1
					],
					"source": [
						"pan_msg_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_msg_1",
						0
					],
					"source": [
						"rec_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rec_2",
						0
					],
					"source": [
						"adc",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rec_2",
						0
					],
					"source": [
						"rec_loop_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rec_2",
						0
					],
					"source": [
						"rec_on_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"grv_2",
						0
					],
					"source": [
						"grv_on_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"grv_2",
						0
					],
					"source": [
						"rate_sig_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_2",
						0
					],
					"source": [
						"grv_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_2",
						1
					],
					"source": [
						"fs_sig_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_boost_2",
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
						"sat_boost_2",
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
						"fs_2",
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
						"vclip_2",
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
						0
					],
					"source": [
						"vclip_2",
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
						"pan_2",
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
						1
					],
					"source": [
						"pan_msg_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_msg_2",
						0
					],
					"source": [
						"rec_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rec_3",
						0
					],
					"source": [
						"adc",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rec_3",
						0
					],
					"source": [
						"rec_loop_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rec_3",
						0
					],
					"source": [
						"rec_on_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"grv_3",
						0
					],
					"source": [
						"grv_on_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"grv_3",
						0
					],
					"source": [
						"rate_sig_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_3",
						0
					],
					"source": [
						"grv_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_3",
						1
					],
					"source": [
						"fs_sig_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_boost_3",
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
						"sat_boost_3",
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
						"fs_3",
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
						"vclip_3",
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
						0
					],
					"source": [
						"vclip_3",
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
						"pan_3",
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
						1
					],
					"source": [
						"pan_msg_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_msg_3",
						0
					],
					"source": [
						"rec_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rec_4",
						0
					],
					"source": [
						"adc",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rec_4",
						0
					],
					"source": [
						"rec_loop_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rec_4",
						0
					],
					"source": [
						"rec_on_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"grv_4",
						0
					],
					"source": [
						"grv_on_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"grv_4",
						0
					],
					"source": [
						"rate_sig_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_4",
						0
					],
					"source": [
						"grv_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"fs_4",
						1
					],
					"source": [
						"fs_sig_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sat_boost_4",
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
						"sat_boost_4",
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
						"fs_4",
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
						"vclip_4",
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
						0
					],
					"source": [
						"vclip_4",
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
						"pan_4",
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
						1
					],
					"source": [
						"pan_msg_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pan_msg_4",
						0
					],
					"source": [
						"rec_delay",
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
					]
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
					]
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
					]
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
				"type": "JSON",
				"implicit": 1
			}
		],
		"autosave": 0
	}
}