{
	"patcher": {
		"fileversion": 1,
		"appversion": {
			"major": 8,
			"minor": 6,
			"revision": 2,
			"architecture": "x64",
			"modernui": 1
		},
		"classnamespace": "dsp.toplevel",
		"rect": [
			50.0,
			80.0,
			2300.0,
			1000.0
		],
		"gridsize": [
			15.0,
			15.0
		],
		"boxes": [
			{
				"box": {
					"id": "loadbang",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"patching_rect": [
						50,
						20,
						70,
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
						50,
						70,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "delay 100"
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
						80,
						90,
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
					"id": "lbl_input",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						50,
						40,
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
						50,
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
						54,
						120,
						22
					],
					"outlettype": [],
					"text": "<-- enable audio"
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
					"id": "lbl_adc",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						120,
						84,
						70,
						22
					],
					"outlettype": [],
					"text": "guitar in"
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
						110,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.3"
				}
			},
			{
				"box": {
					"id": "lbl_dry",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						120,
						114,
						100,
						22
					],
					"outlettype": [],
					"text": "dry (monitor)"
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
						40,
						200,
						22
					],
					"outlettype": [],
					"text": "=== TIMER 80bpm / 9min ==="
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
						50,
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
						54,
						50,
						22
					],
					"outlettype": [],
					"text": "START"
				}
			},
			{
				"box": {
					"id": "stop_btn",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						380,
						50,
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
					"id": "lbl_stop",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						410,
						54,
						50,
						22
					],
					"outlettype": [],
					"text": "STOP"
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
						82,
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
						380,
						82,
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
					"id": "metro_qn",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						300,
						110,
						80,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "metro 750"
				}
			},
			{
				"box": {
					"id": "metro_8th",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						400,
						110,
						80,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "metro 375"
				}
			},
			{
				"box": {
					"id": "qn_counter",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 4,
					"patching_rect": [
						300,
						140,
						70,
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
					"id": "qn_to_ms",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						300,
						170,
						60,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "* 750"
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
						70,
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
					"id": "time_disp",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						300,
						230,
						65,
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
					"id": "lbl_tsec",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						370,
						234,
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
						450,
						200,
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
					"id": "min_disp",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						450,
						230,
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
					"id": "lbl_tmin",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						515,
						234,
						30,
						22
					],
					"outlettype": [],
					"text": "min"
				}
			},
			{
				"box": {
					"id": "lbl_bpm",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						300,
						265,
						90,
						22
					],
					"outlettype": [],
					"text": "BPM (ms/qn):"
				}
			},
			{
				"box": {
					"id": "bpm_num",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						395,
						265,
						50,
						22
					],
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "msg_bpm_init",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						395,
						293,
						40,
						22
					],
					"outlettype": [
						""
					],
					"text": "750"
				}
			},
			{
				"box": {
					"id": "msg_bpm_qn",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						338,
						293,
						40,
						22
					],
					"outlettype": [
						""
					],
					"text": "750"
				}
			},
			{
				"box": {
					"id": "msg_bpm_8th",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						385,
						293,
						40,
						22
					],
					"outlettype": [
						""
					],
					"text": "375"
				}
			},
			{
				"box": {
					"id": "bpm_half",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						395,
						320,
						35,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "/ 2"
				}
			},
			{
				"box": {
					"id": "click_cycle",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						300,
						330,
						90,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "cycle~ 880"
				}
			},
			{
				"box": {
					"id": "click_env",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 1,
					"patching_rect": [
						300,
						360,
						140,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "adsr~ 2 20 0. 10"
				}
			},
			{
				"box": {
					"id": "click_mult",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						300,
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
					"id": "click_gain",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						300,
						420,
						70,
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
					"id": "msg_click_trig",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						350,
						330,
						45,
						22
					],
					"outlettype": [
						""
					],
					"text": "880"
				}
			},
			{
				"box": {
					"id": "click_toggle",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						400,
						420,
						24,
						24
					],
					"outlettype": [
						"int"
					],
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "lbl_click_tog",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						430,
						424,
						90,
						22
					],
					"outlettype": [],
					"text": "click on/off"
				}
			},
			{
				"box": {
					"id": "lbl_detect",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						600,
						40,
						230,
						22
					],
					"outlettype": [],
					"text": "=== PITCH DETECTION (0-30s) ==="
				}
			},
			{
				"box": {
					"id": "detect_lt",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						600,
						70,
						55,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "< 30."
				}
			},
			{
				"box": {
					"id": "detect_gate",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						600,
						100,
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
					"id": "yin",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						600,
						130,
						110,
						22
					],
					"outlettype": [
						"float",
						"float"
					],
					"text": "yin~ 2048 0.9"
				}
			},
			{
				"box": {
					"id": "ftom_detect",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						600,
						160,
						50,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "ftom"
				}
			},
			{
				"box": {
					"id": "conf_gt",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						710,
						190,
						65,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "> 0.85"
				}
			},
			{
				"box": {
					"id": "gate_hist",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						660,
						250,
						45,
						22
					],
					"outlettype": [
						""
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "round_midi",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						600,
						220,
						55,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "round"
				}
			},
			{
				"box": {
					"id": "int_midi",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						600,
						250,
						35,
						22
					],
					"outlettype": [
						"int",
						"bang"
					],
					"text": "int"
				}
			},
			{
				"box": {
					"id": "note_hist_r",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						600,
						280,
						120,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll note_hist"
				}
			},
			{
				"box": {
					"id": "note_hist_w",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						735,
						280,
						120,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll note_hist"
				}
			},
			{
				"box": {
					"id": "hist_t_a",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						865,
						250,
						70,
						22
					],
					"outlettype": [
						"",
						""
					],
					"text": "trigger i i"
				}
			},
			{
				"box": {
					"id": "hist_t_b",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						950,
						250,
						75,
						22
					],
					"outlettype": [
						"",
						"bang"
					],
					"text": "trigger i b"
				}
			},
			{
				"box": {
					"id": "hist_t_c",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1035,
						250,
						75,
						22
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "trigger b i"
				}
			},
			{
				"box": {
					"id": "hist_f_zero",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1035,
						278,
						32,
						22
					],
					"outlettype": [
						""
					],
					"text": "0."
				}
			},
			{
				"box": {
					"id": "hist_delay",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1125,
						278,
						65,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "delay 0"
				}
			},
			{
				"box": {
					"id": "hist_f",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1035,
						305,
						45,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "f"
				}
			},
			{
				"box": {
					"id": "hist_inc",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1200,
						305,
						35,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "+ 1"
				}
			},
			{
				"box": {
					"id": "hist_join",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1135,
						335,
						120,
						22
					],
					"outlettype": [
						""
					],
					"text": "join @triggers 2"
				}
			},
			{
				"box": {
					"id": "lbl_detect_st",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						600,
						340,
						160,
						22
					],
					"outlettype": [],
					"text": "pitch\u2192MIDI\u2192histogram"
				}
			},
			{
				"box": {
					"id": "lock_pool_btn",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						770,
						70,
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
					"id": "lbl_lock",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						800,
						74,
						150,
						22
					],
					"outlettype": [],
					"text": "LOCK POOL (auto@30s)"
				}
			},
			{
				"box": {
					"id": "pool_coll",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						770,
						130,
						120,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pool_notes"
				}
			},
			{
				"box": {
					"id": "msg_hist_dump",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						770,
						105,
						45,
						22
					],
					"outlettype": [
						""
					],
					"text": "dump"
				}
			},
			{
				"box": {
					"id": "pool_count",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 4,
					"patching_rect": [
						830,
						130,
						80,
						22
					],
					"outlettype": [
						"int",
						"",
						"",
						"int"
					],
					"text": "counter 0 4"
				}
			},
			{
				"box": {
					"id": "pool_store_pack",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						920,
						130,
						60,
						22
					],
					"outlettype": [
						""
					],
					"text": "pak 0 0"
				}
			},
			{
				"box": {
					"id": "pool_store_msg",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						990,
						130,
						90,
						22
					],
					"outlettype": [
						""
					],
					"text": "prepend store"
				}
			},
			{
				"box": {
					"id": "msg_fetch_ref",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						770,
						165,
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
					"id": "mtof_ref",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						810,
						165,
						45,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "mtof"
				}
			},
			{
				"box": {
					"id": "lbl_record",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						900,
						40,
						220,
						22
					],
					"outlettype": [],
					"text": "=== RECORD BUFFER (0-30s) ==="
				}
			},
			{
				"box": {
					"id": "rec_buf",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						900,
						70,
						200,
						22
					],
					"outlettype": [],
					"text": "buffer~ lapopie_rec 30000"
				}
			},
			{
				"box": {
					"id": "record",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						900,
						105,
						160,
						22
					],
					"outlettype": [
						""
					],
					"text": "record~ lapopie_rec"
				}
			},
			{
				"box": {
					"id": "msg_rec_on",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1070,
						70,
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
					"id": "msg_rec_off",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1105,
						70,
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
					"id": "lbl_rec_gate",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1070,
						100,
						170,
						22
					],
					"outlettype": [],
					"text": "auto-gated via scheduler"
				}
			},
			{
				"box": {
					"id": "rec_indicator",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						900,
						140,
						24,
						24
					],
					"outlettype": [
						"int"
					],
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "lbl_rec_ind",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						930,
						144,
						70,
						22
					],
					"outlettype": [],
					"text": "REC active"
				}
			},
			{
				"box": {
					"id": "lbl_sched",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1150,
						40,
						180,
						22
					],
					"outlettype": [],
					"text": "=== VOICE SCHEDULER ==="
				}
			},
			{
				"box": {
					"id": "sched_round",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1150,
						70,
						55,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "round"
				}
			},
			{
				"box": {
					"id": "sched_int",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1150,
						100,
						35,
						22
					],
					"outlettype": [
						"int",
						"bang"
					],
					"text": "int"
				}
			},
			{
				"box": {
					"id": "sched_change",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1150,
						130,
						60,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "change"
				}
			},
			{
				"box": {
					"id": "sched_sel",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 14,
					"patching_rect": [
						1150,
						160,
						366,
						22
					],
					"outlettype": [
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang"
					],
					"text": "sel 30 60 90 120 150 240 270 330 360 390 468 480 540"
				}
			},
			{
				"box": {
					"id": "msg_v1_on_30",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1400,
						160,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "on 1"
				}
			},
			{
				"box": {
					"id": "msg_lock_30",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1350,
						160,
						40,
						22
					],
					"outlettype": [
						""
					],
					"text": "bang"
				}
			},
			{
				"box": {
					"id": "msg_v2_on_60",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1450,
						182,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "on 2"
				}
			},
			{
				"box": {
					"id": "msg_v3_on_90",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1500,
						204,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "on 3"
				}
			},
			{
				"box": {
					"id": "msg_v1_off_120",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1400,
						266,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "off 1"
				}
			},
			{
				"box": {
					"id": "msg_v4_on_120",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1550,
						226,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "on 4"
				}
			},
			{
				"box": {
					"id": "msg_v1_on_150",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1400,
						248,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "on 1"
				}
			},
			{
				"box": {
					"id": "msg_v1_off_240",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1400,
						310,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "off 1"
				}
			},
			{
				"box": {
					"id": "msg_v3_off_240",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1500,
						310,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "off 3"
				}
			},
			{
				"box": {
					"id": "msg_v3_on_240",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1500,
						270,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "on 3"
				}
			},
			{
				"box": {
					"id": "msg_v1_on_270",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1400,
						292,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "on 1"
				}
			},
			{
				"box": {
					"id": "msg_v2_off_270",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1450,
						332,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "off 2"
				}
			},
			{
				"box": {
					"id": "msg_v2_on_330",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1450,
						314,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "on 2"
				}
			},
			{
				"box": {
					"id": "msg_v1_off_360",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1400,
						376,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "off 1"
				}
			},
			{
				"box": {
					"id": "msg_v1_on_390",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1400,
						358,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "on 1"
				}
			},
			{
				"box": {
					"id": "msg_v3_off_390",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1500,
						398,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "off 3"
				}
			},
			{
				"box": {
					"id": "msg_v3_on_390",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1500,
						358,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "on 3"
				}
			},
			{
				"box": {
					"id": "msg_v1_taper_468",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1400,
						460,
						60,
						22
					],
					"outlettype": [
						""
					],
					"text": "taper 1"
				}
			},
			{
				"box": {
					"id": "msg_v4_taper_468",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1550,
						460,
						60,
						22
					],
					"outlettype": [
						""
					],
					"text": "taper 4"
				}
			},
			{
				"box": {
					"id": "msg_v1_off_480",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1400,
						442,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "off 1"
				}
			},
			{
				"box": {
					"id": "msg_v4_off_480",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1550,
						442,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "off 4"
				}
			},
			{
				"box": {
					"id": "msg_v2_off_540",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1450,
						464,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "off 2"
				}
			},
			{
				"box": {
					"id": "msg_v3_off_540",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1500,
						464,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "off 3"
				}
			},
			{
				"box": {
					"id": "msg_auto_stop",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1410,
						424,
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
					"id": "lbl_engine",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1450,
						40,
						200,
						22
					],
					"outlettype": [],
					"text": "=== EUCLIDEAN ENGINE ==="
				}
			},
			{
				"box": {
					"id": "pat_bank",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1450,
						70,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "msg_step_0_0",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						70,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "0, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_0_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						84,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "1, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_0_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						98,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "2, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_0_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						112,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "3, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_0_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						126,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "4, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_0_5",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						140,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "5, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_0_6",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						154,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "6, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_0_7",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						168,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "7, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_patlen_0",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						70,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "900, 8 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_1_0",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						182,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "100, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_1_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						196,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "101, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_1_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						210,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "102, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_1_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						224,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "103, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_1_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						238,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "104, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_1_5",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						252,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "105, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_1_6",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						266,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "106, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_1_7",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						280,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "107, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_patlen_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						84,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "901, 8 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_2_0",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						210,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "200, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_2_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						224,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "201, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_2_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						238,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "202, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_2_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						252,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "203, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_2_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						266,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "204, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_patlen_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						98,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "902, 5 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_3_0",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						280,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "300, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_3_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						294,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "301, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_3_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						308,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "302, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_3_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						322,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "303, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_3_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						336,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "304, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_patlen_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						112,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "903, 5 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_4_0",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						462,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "400, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_4_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						476,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "401, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_4_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						490,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "402, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_4_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						504,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "403, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_4_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						518,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "404, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_4_5",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						532,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "405, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_4_6",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						546,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "406, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_patlen_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						126,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "904, 7 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_5_0",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						560,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "500, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_5_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						574,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "501, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_5_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						588,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "502, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_5_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						602,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "503, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_5_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						616,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "504, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_5_5",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						630,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "505, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_5_6",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						644,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "506, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_patlen_5",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						140,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "905, 7 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_6_0",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						658,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "600, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_6_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						672,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "601, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_6_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						686,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "602, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_6_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						700,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "603, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_6_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						714,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "604, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_6_5",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						728,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "605, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_6_6",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1760,
						742,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "606, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_patlen_6",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						154,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "906, 7 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_7_0",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						952,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "700, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_7_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						966,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "701, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_7_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						980,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "702, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_7_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						994,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "703, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_7_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						1008,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "704, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_7_5",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						1022,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "705, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_7_6",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						1036,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "706, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_7_7",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						1050,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "707, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_7_8",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1960,
						1064,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "708, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_patlen_7",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						168,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "907, 9 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_8_0",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						1078,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "800, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_8_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						1092,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "801, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_8_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						1106,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "802, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_8_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						1120,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "803, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_8_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						1134,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "804, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_8_5",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						1148,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "805, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_8_6",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						1162,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "806, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_8_7",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						1176,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "807, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_8_8",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2160,
						1190,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "808, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_patlen_8",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						182,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "908, 9 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_9_0",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						1582,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "900, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_9_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						1596,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "901, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_9_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						1610,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "902, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_9_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						1624,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "903, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_9_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						1638,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "904, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_9_5",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						1652,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "905, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_9_6",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						1666,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "906, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_9_7",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						1680,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "907, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_9_8",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						1694,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "908, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_9_9",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						1708,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "909, 0 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_9_10",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						1722,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "910, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_step_9_11",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						1736,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "911, 1 ;"
				}
			},
			{
				"box": {
					"id": "msg_patlen_9",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1560,
						196,
						80,
						22
					],
					"outlettype": [
						""
					],
					"text": "909, 12 ;"
				}
			},
			{
				"box": {
					"id": "pat_init_lb",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"patching_rect": [
						1850,
						70,
						70,
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
					"id": "pat_init_delay",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1850,
						100,
						70,
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
					"id": "pat_init_trig",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 87,
					"patching_rect": [
						1850,
						130,
						600,
						22
					],
					"outlettype": [
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang",
						"bang"
					],
					"text": "trigger bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang bang"
				}
			},
			{
				"box": {
					"id": "note_order_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1450,
						300,
						140,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll note_order_1"
				}
			},
			{
				"box": {
					"id": "note_order_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1450,
						460,
						140,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll note_order_2"
				}
			},
			{
				"box": {
					"id": "note_order_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1450,
						620,
						140,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll note_order_3"
				}
			},
			{
				"box": {
					"id": "note_order_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1450,
						780,
						140,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll note_order_4"
				}
			},
			{
				"box": {
					"id": "lbl_vc_1",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1450,
						282,
						220,
						22
					],
					"outlettype": [],
					"text": "--- VOICE G1 (pan=25.0, vol=0.82) ---"
				}
			},
			{
				"box": {
					"id": "voice_ctrl_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 4,
					"patching_rect": [
						1450,
						300,
						110,
						22
					],
					"outlettype": [
						"",
						"",
						"",
						""
					],
					"text": "route on off taper"
				}
			},
			{
				"box": {
					"id": "rand_pat_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1570,
						300,
						70,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "random 10"
				}
			},
			{
				"box": {
					"id": "pat_last_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1650,
						300,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "pat_eq_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1690,
						300,
						40,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "=="
				}
			},
			{
				"box": {
					"id": "pat_dedup_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1740,
						300,
						50,
						22
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel 1"
				}
			},
			{
				"box": {
					"id": "pat_inc_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						300,
						40,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "+ 1"
				}
			},
			{
				"box": {
					"id": "pat_mod_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1795,
						300,
						55,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "% 10"
				}
			},
			{
				"box": {
					"id": "cur_pat_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1855,
						300,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "pat_fetch_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1890,
						300,
						55,
						22
					],
					"outlettype": [
						"",
						""
					],
					"text": "route"
				}
			},
			{
				"box": {
					"id": "step_ctr_1",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 4,
					"patching_rect": [
						1955,
						300,
						85,
						22
					],
					"outlettype": [
						"int",
						"",
						"",
						"int"
					],
					"text": "counter 0 7"
				}
			},
			{
				"box": {
					"id": "patlen_key_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1855,
						330,
						55,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "+ 900"
				}
			},
			{
				"box": {
					"id": "patlen_fetch_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1915,
						330,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "patlen_sub1_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2020,
						330,
						40,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "- 1"
				}
			},
			{
				"box": {
					"id": "patlen_setmax_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2068,
						330,
						90,
						22
					],
					"outlettype": [
						""
					],
					"text": "prepend setmax"
				}
			},
			{
				"box": {
					"id": "step_gate_1",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						300,
						24,
						24
					],
					"outlettype": [
						"int"
					],
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "lbl_sg_1",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2080,
						304,
						35,
						22
					],
					"outlettype": [],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "step_fetch_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1955,
						330,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "step_key_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1955,
						360,
						140,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "expr $i1 * 100 + $i2"
				}
			},
			{
				"box": {
					"id": "cur_pat_i_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1855,
						360,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "step_lookup_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						2100,
						330,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "step_sel_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						2210,
						330,
						50,
						22
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel 1"
				}
			},
			{
				"box": {
					"id": "note_ctr_1",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 4,
					"patching_rect": [
						2270,
						330,
						85,
						22
					],
					"outlettype": [
						"int",
						"",
						"",
						"int"
					],
					"text": "counter 0 4"
				}
			},
			{
				"box": {
					"id": "note_key_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						330,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "note_fetch_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						2400,
						330,
						130,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll note_order_1"
				}
			},
			{
				"box": {
					"id": "mtof_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2535,
						330,
						50,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "mtof"
				}
			},
			{
				"box": {
					"id": "lbl_v1_end",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2590,
						330,
						120,
						22
					],
					"outlettype": [],
					"text": "\u2192 to playback G1"
				}
			},
			{
				"box": {
					"id": "on_trig_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1450,
						325,
						110,
						22
					],
					"outlettype": [
						"bang",
						"bang"
					],
					"text": "trigger bang bang"
				}
			},
			{
				"box": {
					"id": "msg_gate_on_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1570,
						325,
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
					"id": "msg_gate_off_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1570,
						350,
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
					"id": "gate_obj_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						330,
						55,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "gate 1"
				}
			},
			{
				"box": {
					"id": "lbl_vc_2",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1450,
						442,
						220,
						22
					],
					"outlettype": [],
					"text": "--- VOICE G2 (pan=-25.0, vol=0.78) ---"
				}
			},
			{
				"box": {
					"id": "voice_ctrl_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 4,
					"patching_rect": [
						1450,
						460,
						110,
						22
					],
					"outlettype": [
						"",
						"",
						"",
						""
					],
					"text": "route on off taper"
				}
			},
			{
				"box": {
					"id": "rand_pat_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1570,
						460,
						70,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "random 10"
				}
			},
			{
				"box": {
					"id": "pat_last_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1650,
						460,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "pat_eq_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1690,
						460,
						40,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "=="
				}
			},
			{
				"box": {
					"id": "pat_dedup_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1740,
						460,
						50,
						22
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel 1"
				}
			},
			{
				"box": {
					"id": "pat_inc_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						460,
						40,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "+ 1"
				}
			},
			{
				"box": {
					"id": "pat_mod_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1795,
						460,
						55,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "% 10"
				}
			},
			{
				"box": {
					"id": "cur_pat_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1855,
						460,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "pat_fetch_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1890,
						460,
						55,
						22
					],
					"outlettype": [
						"",
						""
					],
					"text": "route"
				}
			},
			{
				"box": {
					"id": "step_ctr_2",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 4,
					"patching_rect": [
						1955,
						460,
						85,
						22
					],
					"outlettype": [
						"int",
						"",
						"",
						"int"
					],
					"text": "counter 0 7"
				}
			},
			{
				"box": {
					"id": "patlen_key_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1855,
						490,
						55,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "+ 900"
				}
			},
			{
				"box": {
					"id": "patlen_fetch_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1915,
						490,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "patlen_sub1_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2020,
						490,
						40,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "- 1"
				}
			},
			{
				"box": {
					"id": "patlen_setmax_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2068,
						490,
						90,
						22
					],
					"outlettype": [
						""
					],
					"text": "prepend setmax"
				}
			},
			{
				"box": {
					"id": "step_gate_2",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						460,
						24,
						24
					],
					"outlettype": [
						"int"
					],
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "lbl_sg_2",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2080,
						464,
						35,
						22
					],
					"outlettype": [],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "step_fetch_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1955,
						490,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "step_key_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1955,
						520,
						140,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "expr $i1 * 100 + $i2"
				}
			},
			{
				"box": {
					"id": "cur_pat_i_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1855,
						520,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "step_lookup_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						2100,
						490,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "step_sel_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						2210,
						490,
						50,
						22
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel 1"
				}
			},
			{
				"box": {
					"id": "note_ctr_2",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 4,
					"patching_rect": [
						2270,
						490,
						85,
						22
					],
					"outlettype": [
						"int",
						"",
						"",
						"int"
					],
					"text": "counter 0 4"
				}
			},
			{
				"box": {
					"id": "note_key_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						490,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "note_fetch_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						2400,
						490,
						130,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll note_order_2"
				}
			},
			{
				"box": {
					"id": "mtof_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2535,
						490,
						50,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "mtof"
				}
			},
			{
				"box": {
					"id": "lbl_v2_end",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2590,
						490,
						120,
						22
					],
					"outlettype": [],
					"text": "\u2192 to playback G2"
				}
			},
			{
				"box": {
					"id": "on_trig_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1450,
						485,
						110,
						22
					],
					"outlettype": [
						"bang",
						"bang"
					],
					"text": "trigger bang bang"
				}
			},
			{
				"box": {
					"id": "msg_gate_on_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1570,
						485,
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
					"id": "msg_gate_off_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1570,
						510,
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
					"id": "gate_obj_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						490,
						55,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "gate 1"
				}
			},
			{
				"box": {
					"id": "lbl_vc_3",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1450,
						602,
						220,
						22
					],
					"outlettype": [],
					"text": "--- VOICE G3 (pan=50.0, vol=0.72) ---"
				}
			},
			{
				"box": {
					"id": "voice_ctrl_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 4,
					"patching_rect": [
						1450,
						620,
						110,
						22
					],
					"outlettype": [
						"",
						"",
						"",
						""
					],
					"text": "route on off taper"
				}
			},
			{
				"box": {
					"id": "rand_pat_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1570,
						620,
						70,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "random 10"
				}
			},
			{
				"box": {
					"id": "pat_last_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1650,
						620,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "pat_eq_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1690,
						620,
						40,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "=="
				}
			},
			{
				"box": {
					"id": "pat_dedup_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1740,
						620,
						50,
						22
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel 1"
				}
			},
			{
				"box": {
					"id": "pat_inc_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						620,
						40,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "+ 1"
				}
			},
			{
				"box": {
					"id": "pat_mod_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1795,
						620,
						55,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "% 10"
				}
			},
			{
				"box": {
					"id": "cur_pat_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1855,
						620,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "pat_fetch_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1890,
						620,
						55,
						22
					],
					"outlettype": [
						"",
						""
					],
					"text": "route"
				}
			},
			{
				"box": {
					"id": "step_ctr_3",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 4,
					"patching_rect": [
						1955,
						620,
						85,
						22
					],
					"outlettype": [
						"int",
						"",
						"",
						"int"
					],
					"text": "counter 0 7"
				}
			},
			{
				"box": {
					"id": "patlen_key_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1855,
						650,
						55,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "+ 900"
				}
			},
			{
				"box": {
					"id": "patlen_fetch_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1915,
						650,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "patlen_sub1_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2020,
						650,
						40,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "- 1"
				}
			},
			{
				"box": {
					"id": "patlen_setmax_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2068,
						650,
						90,
						22
					],
					"outlettype": [
						""
					],
					"text": "prepend setmax"
				}
			},
			{
				"box": {
					"id": "step_gate_3",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						620,
						24,
						24
					],
					"outlettype": [
						"int"
					],
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "lbl_sg_3",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2080,
						624,
						35,
						22
					],
					"outlettype": [],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "step_fetch_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1955,
						650,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "step_key_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1955,
						680,
						140,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "expr $i1 * 100 + $i2"
				}
			},
			{
				"box": {
					"id": "cur_pat_i_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1855,
						680,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "step_lookup_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						2100,
						650,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "step_sel_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						2210,
						650,
						50,
						22
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel 1"
				}
			},
			{
				"box": {
					"id": "note_ctr_3",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 4,
					"patching_rect": [
						2270,
						650,
						85,
						22
					],
					"outlettype": [
						"int",
						"",
						"",
						"int"
					],
					"text": "counter 0 4"
				}
			},
			{
				"box": {
					"id": "note_key_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						650,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "note_fetch_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						2400,
						650,
						130,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll note_order_3"
				}
			},
			{
				"box": {
					"id": "mtof_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2535,
						650,
						50,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "mtof"
				}
			},
			{
				"box": {
					"id": "lbl_v3_end",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2590,
						650,
						120,
						22
					],
					"outlettype": [],
					"text": "\u2192 to playback G3"
				}
			},
			{
				"box": {
					"id": "on_trig_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1450,
						645,
						110,
						22
					],
					"outlettype": [
						"bang",
						"bang"
					],
					"text": "trigger bang bang"
				}
			},
			{
				"box": {
					"id": "msg_gate_on_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1570,
						645,
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
					"id": "msg_gate_off_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1570,
						670,
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
					"id": "gate_obj_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						650,
						55,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "gate 1"
				}
			},
			{
				"box": {
					"id": "lbl_vc_4",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1450,
						762,
						220,
						22
					],
					"outlettype": [],
					"text": "--- VOICE G4 (pan=-50.0, vol=0.68) ---"
				}
			},
			{
				"box": {
					"id": "voice_ctrl_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 4,
					"patching_rect": [
						1450,
						780,
						110,
						22
					],
					"outlettype": [
						"",
						"",
						"",
						""
					],
					"text": "route on off taper"
				}
			},
			{
				"box": {
					"id": "rand_pat_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1570,
						780,
						70,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "random 10"
				}
			},
			{
				"box": {
					"id": "pat_last_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1650,
						780,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "pat_eq_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1690,
						780,
						40,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "=="
				}
			},
			{
				"box": {
					"id": "pat_dedup_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1740,
						780,
						50,
						22
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel 1"
				}
			},
			{
				"box": {
					"id": "pat_inc_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						780,
						40,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "+ 1"
				}
			},
			{
				"box": {
					"id": "pat_mod_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1795,
						780,
						55,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "% 10"
				}
			},
			{
				"box": {
					"id": "cur_pat_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1855,
						780,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "pat_fetch_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1890,
						780,
						55,
						22
					],
					"outlettype": [
						"",
						""
					],
					"text": "route"
				}
			},
			{
				"box": {
					"id": "step_ctr_4",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 4,
					"patching_rect": [
						1955,
						780,
						85,
						22
					],
					"outlettype": [
						"int",
						"",
						"",
						"int"
					],
					"text": "counter 0 7"
				}
			},
			{
				"box": {
					"id": "patlen_key_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1855,
						810,
						55,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "+ 900"
				}
			},
			{
				"box": {
					"id": "patlen_fetch_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1915,
						810,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "patlen_sub1_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2020,
						810,
						40,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "- 1"
				}
			},
			{
				"box": {
					"id": "patlen_setmax_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2068,
						810,
						90,
						22
					],
					"outlettype": [
						""
					],
					"text": "prepend setmax"
				}
			},
			{
				"box": {
					"id": "step_gate_4",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						780,
						24,
						24
					],
					"outlettype": [
						"int"
					],
					"parameter_enable": 0
				}
			},
			{
				"box": {
					"id": "lbl_sg_4",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2080,
						784,
						35,
						22
					],
					"outlettype": [],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "step_fetch_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						1955,
						810,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "step_key_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1955,
						840,
						140,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "expr $i1 * 100 + $i2"
				}
			},
			{
				"box": {
					"id": "cur_pat_i_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1855,
						840,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "step_lookup_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						2100,
						810,
						100,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll pat_bank"
				}
			},
			{
				"box": {
					"id": "step_sel_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						2210,
						810,
						50,
						22
					],
					"outlettype": [
						"bang",
						""
					],
					"text": "sel 1"
				}
			},
			{
				"box": {
					"id": "note_ctr_4",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 4,
					"patching_rect": [
						2270,
						810,
						85,
						22
					],
					"outlettype": [
						"int",
						"",
						"",
						"int"
					],
					"text": "counter 0 4"
				}
			},
			{
				"box": {
					"id": "note_key_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2360,
						810,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "note_fetch_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"patching_rect": [
						2400,
						810,
						130,
						22
					],
					"outlettype": [
						"",
						"",
						""
					],
					"text": "coll note_order_4"
				}
			},
			{
				"box": {
					"id": "mtof_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						2535,
						810,
						50,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "mtof"
				}
			},
			{
				"box": {
					"id": "lbl_v4_end",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2590,
						810,
						120,
						22
					],
					"outlettype": [],
					"text": "\u2192 to playback G4"
				}
			},
			{
				"box": {
					"id": "on_trig_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1450,
						805,
						110,
						22
					],
					"outlettype": [
						"bang",
						"bang"
					],
					"text": "trigger bang bang"
				}
			},
			{
				"box": {
					"id": "msg_gate_on_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1570,
						805,
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
					"id": "msg_gate_off_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1570,
						830,
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
					"id": "gate_obj_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						810,
						55,
						22
					],
					"outlettype": [
						"bang"
					],
					"text": "gate 1"
				}
			},
			{
				"box": {
					"id": "lbl_play",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1750,
						40,
						160,
						22
					],
					"outlettype": [],
					"text": "=== PLAYBACK ==="
				}
			},
			{
				"box": {
					"id": "ref_hz",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"patching_rect": [
						1750,
						70,
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
					"id": "lbl_ref",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1830,
						74,
						110,
						22
					],
					"outlettype": [],
					"text": "ref hz (pool[0])"
				}
			},
			{
				"box": {
					"id": "lbl_play_1",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1750,
						92,
						30,
						22
					],
					"outlettype": [],
					"text": "G1"
				}
			},
			{
				"box": {
					"id": "rate_div_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						110,
						55,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 1."
				}
			},
			{
				"box": {
					"id": "rate_pack_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						140,
						70,
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
					"id": "rate_line_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						170,
						80,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "line 1. 50"
				}
			},
			{
				"box": {
					"id": "groove_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1750,
						205,
						150,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "groove~ lapopie_rec"
				}
			},
			{
				"box": {
					"id": "start_rand_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						110,
						90,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "random 20000"
				}
			},
			{
				"box": {
					"id": "start_float_1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						140,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "msg_loopst_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						170,
						110,
						22
					],
					"outlettype": [
						""
					],
					"text": "loopstart $1"
				}
			},
			{
				"box": {
					"id": "msg_loopdur_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						200,
						100,
						22
					],
					"outlettype": [
						""
					],
					"text": "loopdur 400"
				}
			},
			{
				"box": {
					"id": "lb_loopdur_1",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						225,
						70,
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
					"id": "vol_sig_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						240,
						65,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.82"
				}
			},
			{
				"box": {
					"id": "vol_env_1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1830,
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
					"id": "msg_vol_on_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1830,
						215,
						60,
						22
					],
					"outlettype": [
						""
					],
					"text": "0.82 30"
				}
			},
			{
				"box": {
					"id": "msg_vol_off_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1900,
						215,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "0. 50"
				}
			},
			{
				"box": {
					"id": "msg_vol_taper_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1965,
						215,
						75,
						22
					],
					"outlettype": [
						""
					],
					"text": "0. 12000"
				}
			},
			{
				"box": {
					"id": "pan_1",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						1750,
						275,
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
					"id": "msg_pan_1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1810,
						275,
						42,
						22
					],
					"outlettype": [
						""
					],
					"text": "25.0"
				}
			},
			{
				"box": {
					"id": "lbl_play_2",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1750,
						252,
						30,
						22
					],
					"outlettype": [],
					"text": "G2"
				}
			},
			{
				"box": {
					"id": "rate_div_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						270,
						55,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 1."
				}
			},
			{
				"box": {
					"id": "rate_pack_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						300,
						70,
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
					"id": "rate_line_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						330,
						80,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "line 1. 50"
				}
			},
			{
				"box": {
					"id": "groove_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1750,
						365,
						150,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "groove~ lapopie_rec"
				}
			},
			{
				"box": {
					"id": "start_rand_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						270,
						90,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "random 20000"
				}
			},
			{
				"box": {
					"id": "start_float_2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						300,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "msg_loopst_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						330,
						110,
						22
					],
					"outlettype": [
						""
					],
					"text": "loopstart $1"
				}
			},
			{
				"box": {
					"id": "msg_loopdur_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						360,
						100,
						22
					],
					"outlettype": [
						""
					],
					"text": "loopdur 400"
				}
			},
			{
				"box": {
					"id": "lb_loopdur_2",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						385,
						70,
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
					"id": "vol_sig_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						400,
						65,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.78"
				}
			},
			{
				"box": {
					"id": "vol_env_2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1830,
						400,
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
					"id": "msg_vol_on_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1830,
						375,
						60,
						22
					],
					"outlettype": [
						""
					],
					"text": "0.78 30"
				}
			},
			{
				"box": {
					"id": "msg_vol_off_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1900,
						375,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "0. 50"
				}
			},
			{
				"box": {
					"id": "msg_vol_taper_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1965,
						375,
						75,
						22
					],
					"outlettype": [
						""
					],
					"text": "0. 12000"
				}
			},
			{
				"box": {
					"id": "pan_2",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						1750,
						435,
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
					"id": "msg_pan_2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1810,
						435,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "-25.0"
				}
			},
			{
				"box": {
					"id": "lbl_play_3",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1750,
						412,
						30,
						22
					],
					"outlettype": [],
					"text": "G3"
				}
			},
			{
				"box": {
					"id": "rate_div_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						430,
						55,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 1."
				}
			},
			{
				"box": {
					"id": "rate_pack_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						460,
						70,
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
					"id": "rate_line_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						490,
						80,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "line 1. 50"
				}
			},
			{
				"box": {
					"id": "groove_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1750,
						525,
						150,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "groove~ lapopie_rec"
				}
			},
			{
				"box": {
					"id": "start_rand_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						430,
						90,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "random 20000"
				}
			},
			{
				"box": {
					"id": "start_float_3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						460,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "msg_loopst_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						490,
						110,
						22
					],
					"outlettype": [
						""
					],
					"text": "loopstart $1"
				}
			},
			{
				"box": {
					"id": "msg_loopdur_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						520,
						100,
						22
					],
					"outlettype": [
						""
					],
					"text": "loopdur 400"
				}
			},
			{
				"box": {
					"id": "lb_loopdur_3",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						545,
						70,
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
					"id": "vol_sig_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						560,
						65,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.72"
				}
			},
			{
				"box": {
					"id": "vol_env_3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1830,
						560,
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
					"id": "msg_vol_on_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1830,
						535,
						60,
						22
					],
					"outlettype": [
						""
					],
					"text": "0.72 30"
				}
			},
			{
				"box": {
					"id": "msg_vol_off_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1900,
						535,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "0. 50"
				}
			},
			{
				"box": {
					"id": "msg_vol_taper_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1965,
						535,
						75,
						22
					],
					"outlettype": [
						""
					],
					"text": "0. 12000"
				}
			},
			{
				"box": {
					"id": "pan_3",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						1750,
						595,
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
					"id": "msg_pan_3",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1810,
						595,
						42,
						22
					],
					"outlettype": [
						""
					],
					"text": "50.0"
				}
			},
			{
				"box": {
					"id": "lbl_play_4",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1750,
						572,
						30,
						22
					],
					"outlettype": [],
					"text": "G4"
				}
			},
			{
				"box": {
					"id": "rate_div_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						590,
						55,
						22
					],
					"outlettype": [
						"float"
					],
					"text": "/ 1."
				}
			},
			{
				"box": {
					"id": "rate_pack_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						620,
						70,
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
					"id": "rate_line_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						650,
						80,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "line 1. 50"
				}
			},
			{
				"box": {
					"id": "groove_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1750,
						685,
						150,
						22
					],
					"outlettype": [
						"signal",
						"signal"
					],
					"text": "groove~ lapopie_rec"
				}
			},
			{
				"box": {
					"id": "start_rand_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						590,
						90,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "random 20000"
				}
			},
			{
				"box": {
					"id": "start_float_4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						620,
						30,
						22
					],
					"outlettype": [
						"int"
					],
					"text": "i"
				}
			},
			{
				"box": {
					"id": "msg_loopst_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						650,
						110,
						22
					],
					"outlettype": [
						""
					],
					"text": "loopstart $1"
				}
			},
			{
				"box": {
					"id": "msg_loopdur_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						680,
						100,
						22
					],
					"outlettype": [
						""
					],
					"text": "loopdur 400"
				}
			},
			{
				"box": {
					"id": "lb_loopdur_4",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"patching_rect": [
						1910,
						705,
						70,
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
					"id": "vol_sig_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1750,
						720,
						65,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "*~ 0.68"
				}
			},
			{
				"box": {
					"id": "vol_env_4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"patching_rect": [
						1830,
						720,
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
					"id": "msg_vol_on_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1830,
						695,
						60,
						22
					],
					"outlettype": [
						""
					],
					"text": "0.68 30"
				}
			},
			{
				"box": {
					"id": "msg_vol_off_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1900,
						695,
						55,
						22
					],
					"outlettype": [
						""
					],
					"text": "0. 50"
				}
			},
			{
				"box": {
					"id": "msg_vol_taper_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1965,
						695,
						75,
						22
					],
					"outlettype": [
						""
					],
					"text": "0. 12000"
				}
			},
			{
				"box": {
					"id": "pan_4",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 2,
					"patching_rect": [
						1750,
						755,
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
					"id": "msg_pan_4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						1810,
						755,
						50,
						22
					],
					"outlettype": [
						""
					],
					"text": "-50.0"
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
						40,
						160,
						22
					],
					"outlettype": [],
					"text": "=== MIX / OUTPUT ==="
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
						80,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0."
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
						80,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0."
				}
			},
			{
				"box": {
					"id": "mix_L2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						110,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0."
				}
			},
			{
				"box": {
					"id": "mix_R2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2130,
						110,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0."
				}
			},
			{
				"box": {
					"id": "mix_L3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						140,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0."
				}
			},
			{
				"box": {
					"id": "mix_R3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2130,
						140,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0."
				}
			},
			{
				"box": {
					"id": "mix_dry_L",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						170,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0."
				}
			},
			{
				"box": {
					"id": "mix_dry_R",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2130,
						170,
						55,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "+~ 0."
				}
			},
			{
				"box": {
					"id": "master_L",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						205,
						65,
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
					"id": "master_R",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						2130,
						205,
						65,
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
					"id": "clip_L",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"patching_rect": [
						2050,
						235,
						90,
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
						235,
						90,
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
						2050,
						265,
						44,
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
						300,
						60,
						22
					],
					"outlettype": [
						"signal"
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
						300,
						60,
						22
					],
					"outlettype": [
						"signal"
					],
					"text": "meter~"
				}
			}
		],
		"lines": [
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
						"ezdac",
						0
					],
					"source": [
						"msg_startwindow",
						0
					]
				}
			},
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
						"stop_btn",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"metro_qn",
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
						"metro_qn",
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
						"metro_8th",
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
						"metro_8th",
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
						"qn_counter",
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
						"qn_counter",
						0
					],
					"source": [
						"metro_qn",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"qn_to_ms",
						0
					],
					"source": [
						"qn_counter",
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
						"qn_to_ms",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"time_disp",
						0
					],
					"source": [
						"ms_to_sec",
						0
					]
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
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"min_disp",
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
						"click_env",
						0
					],
					"source": [
						"metro_qn",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"click_mult",
						0
					],
					"source": [
						"click_cycle",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"click_mult",
						1
					],
					"source": [
						"click_env",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"click_gain",
						0
					],
					"source": [
						"click_mult",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"click_gain",
						1
					],
					"source": [
						"click_toggle",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"bpm_half",
						0
					],
					"source": [
						"bpm_num",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"metro_qn",
						1
					],
					"source": [
						"bpm_num",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"metro_8th",
						1
					],
					"source": [
						"bpm_half",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_bpm_init",
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
						"bpm_num",
						0
					],
					"source": [
						"msg_bpm_init",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_hist_dump",
						0
					],
					"source": [
						"lock_pool_btn",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_hist_r",
						0
					],
					"source": [
						"msg_hist_dump",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pool_count",
						0
					],
					"source": [
						"note_hist_r",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pool_store_pack",
						0
					],
					"source": [
						"pool_count",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pool_store_pack",
						1
					],
					"source": [
						"note_hist_r",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pool_store_msg",
						0
					],
					"source": [
						"pool_store_pack",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pool_coll",
						0
					],
					"source": [
						"pool_store_msg",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_fetch_ref",
						0
					],
					"source": [
						"lock_pool_btn",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pool_coll",
						0
					],
					"source": [
						"msg_fetch_ref",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mtof_ref",
						0
					],
					"source": [
						"pool_coll",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"ref_hz",
						0
					],
					"source": [
						"mtof_ref",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"detect_lt",
						0
					],
					"source": [
						"ms_to_sec",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"detect_gate",
						1
					],
					"source": [
						"detect_lt",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"detect_gate",
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
						"yin",
						0
					],
					"source": [
						"detect_gate",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"ftom_detect",
						0
					],
					"source": [
						"yin",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"conf_gt",
						0
					],
					"source": [
						"yin",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"round_midi",
						0
					],
					"source": [
						"ftom_detect",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"int_midi",
						0
					],
					"source": [
						"round_midi",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"gate_hist",
						0
					],
					"source": [
						"int_midi",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"gate_hist",
						1
					],
					"source": [
						"conf_gt",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"hist_t_a",
						0
					],
					"source": [
						"gate_hist",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"hist_join",
						0
					],
					"source": [
						"hist_t_a",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"hist_t_b",
						0
					],
					"source": [
						"hist_t_a",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"hist_f_zero",
						0
					],
					"source": [
						"hist_t_b",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"hist_f",
						1
					],
					"source": [
						"hist_f_zero",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"hist_t_c",
						0
					],
					"source": [
						"hist_t_b",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_hist_r",
						0
					],
					"source": [
						"hist_t_c",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"hist_delay",
						0
					],
					"source": [
						"hist_t_c",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"hist_f",
						1
					],
					"source": [
						"note_hist_r",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"hist_f",
						0
					],
					"source": [
						"hist_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"hist_inc",
						0
					],
					"source": [
						"hist_f",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"hist_join",
						1
					],
					"source": [
						"hist_inc",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_hist_w",
						0
					],
					"source": [
						"hist_join",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"record",
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
						"record",
						2
					],
					"source": [
						"detect_lt",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sched_round",
						0
					],
					"source": [
						"ms_to_sec",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sched_int",
						0
					],
					"source": [
						"sched_round",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sched_change",
						0
					],
					"source": [
						"sched_int",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"sched_sel",
						0
					],
					"source": [
						"sched_change",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v1_on_30",
						0
					],
					"source": [
						"sched_sel",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_1",
						0
					],
					"source": [
						"msg_v1_on_30",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_lock_30",
						0
					],
					"source": [
						"sched_sel",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"lock_pool_btn",
						0
					],
					"source": [
						"msg_lock_30",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v2_on_60",
						0
					],
					"source": [
						"sched_sel",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_2",
						0
					],
					"source": [
						"msg_v2_on_60",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v3_on_90",
						0
					],
					"source": [
						"sched_sel",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_3",
						0
					],
					"source": [
						"msg_v3_on_90",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v1_off_120",
						0
					],
					"source": [
						"sched_sel",
						3
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_1",
						0
					],
					"source": [
						"msg_v1_off_120",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v4_on_120",
						0
					],
					"source": [
						"sched_sel",
						3
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_4",
						0
					],
					"source": [
						"msg_v4_on_120",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v1_on_150",
						0
					],
					"source": [
						"sched_sel",
						4
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_1",
						0
					],
					"source": [
						"msg_v1_on_150",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v1_off_240",
						0
					],
					"source": [
						"sched_sel",
						5
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_1",
						0
					],
					"source": [
						"msg_v1_off_240",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v3_off_240",
						0
					],
					"source": [
						"sched_sel",
						5
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_3",
						0
					],
					"source": [
						"msg_v3_off_240",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v3_on_240",
						0
					],
					"source": [
						"sched_sel",
						5
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_3",
						0
					],
					"source": [
						"msg_v3_on_240",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v1_on_270",
						0
					],
					"source": [
						"sched_sel",
						6
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_1",
						0
					],
					"source": [
						"msg_v1_on_270",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v2_off_270",
						0
					],
					"source": [
						"sched_sel",
						6
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_2",
						0
					],
					"source": [
						"msg_v2_off_270",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v2_on_330",
						0
					],
					"source": [
						"sched_sel",
						7
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_2",
						0
					],
					"source": [
						"msg_v2_on_330",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v1_off_360",
						0
					],
					"source": [
						"sched_sel",
						8
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_1",
						0
					],
					"source": [
						"msg_v1_off_360",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v1_on_390",
						0
					],
					"source": [
						"sched_sel",
						9
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_1",
						0
					],
					"source": [
						"msg_v1_on_390",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v3_off_390",
						0
					],
					"source": [
						"sched_sel",
						9
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_3",
						0
					],
					"source": [
						"msg_v3_off_390",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v3_on_390",
						0
					],
					"source": [
						"sched_sel",
						9
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_3",
						0
					],
					"source": [
						"msg_v3_on_390",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v1_taper_468",
						0
					],
					"source": [
						"sched_sel",
						10
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_1",
						0
					],
					"source": [
						"msg_v1_taper_468",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v4_taper_468",
						0
					],
					"source": [
						"sched_sel",
						10
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_4",
						0
					],
					"source": [
						"msg_v4_taper_468",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v1_off_480",
						0
					],
					"source": [
						"sched_sel",
						11
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_1",
						0
					],
					"source": [
						"msg_v1_off_480",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v4_off_480",
						0
					],
					"source": [
						"sched_sel",
						11
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_4",
						0
					],
					"source": [
						"msg_v4_off_480",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v2_off_540",
						0
					],
					"source": [
						"sched_sel",
						12
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_2",
						0
					],
					"source": [
						"msg_v2_off_540",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_v3_off_540",
						0
					],
					"source": [
						"sched_sel",
						12
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"voice_ctrl_3",
						0
					],
					"source": [
						"msg_v3_off_540",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_auto_stop",
						0
					],
					"source": [
						"sched_sel",
						12
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"metro_qn",
						0
					],
					"source": [
						"msg_auto_stop",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"metro_8th",
						0
					],
					"source": [
						"msg_auto_stop",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_init_delay",
						0
					],
					"source": [
						"pat_init_lb",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_init_trig",
						0
					],
					"source": [
						"pat_init_delay",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_0_0",
						0
					],
					"source": [
						"pat_init_trig",
						86
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_0_0",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_0_1",
						0
					],
					"source": [
						"pat_init_trig",
						85
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_0_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_0_2",
						0
					],
					"source": [
						"pat_init_trig",
						84
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_0_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_0_3",
						0
					],
					"source": [
						"pat_init_trig",
						83
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_0_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_0_4",
						0
					],
					"source": [
						"pat_init_trig",
						82
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_0_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_0_5",
						0
					],
					"source": [
						"pat_init_trig",
						81
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_0_5",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_0_6",
						0
					],
					"source": [
						"pat_init_trig",
						80
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_0_6",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_0_7",
						0
					],
					"source": [
						"pat_init_trig",
						79
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_0_7",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_patlen_0",
						0
					],
					"source": [
						"pat_init_trig",
						78
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_patlen_0",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_1_0",
						0
					],
					"source": [
						"pat_init_trig",
						77
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_1_0",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_1_1",
						0
					],
					"source": [
						"pat_init_trig",
						76
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_1_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_1_2",
						0
					],
					"source": [
						"pat_init_trig",
						75
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_1_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_1_3",
						0
					],
					"source": [
						"pat_init_trig",
						74
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_1_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_1_4",
						0
					],
					"source": [
						"pat_init_trig",
						73
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_1_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_1_5",
						0
					],
					"source": [
						"pat_init_trig",
						72
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_1_5",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_1_6",
						0
					],
					"source": [
						"pat_init_trig",
						71
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_1_6",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_1_7",
						0
					],
					"source": [
						"pat_init_trig",
						70
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_1_7",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_patlen_1",
						0
					],
					"source": [
						"pat_init_trig",
						69
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_patlen_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_2_0",
						0
					],
					"source": [
						"pat_init_trig",
						68
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_2_0",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_2_1",
						0
					],
					"source": [
						"pat_init_trig",
						67
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_2_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_2_2",
						0
					],
					"source": [
						"pat_init_trig",
						66
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_2_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_2_3",
						0
					],
					"source": [
						"pat_init_trig",
						65
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_2_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_2_4",
						0
					],
					"source": [
						"pat_init_trig",
						64
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_2_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_patlen_2",
						0
					],
					"source": [
						"pat_init_trig",
						63
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_patlen_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_3_0",
						0
					],
					"source": [
						"pat_init_trig",
						62
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_3_0",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_3_1",
						0
					],
					"source": [
						"pat_init_trig",
						61
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_3_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_3_2",
						0
					],
					"source": [
						"pat_init_trig",
						60
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_3_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_3_3",
						0
					],
					"source": [
						"pat_init_trig",
						59
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_3_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_3_4",
						0
					],
					"source": [
						"pat_init_trig",
						58
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_3_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_patlen_3",
						0
					],
					"source": [
						"pat_init_trig",
						57
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_patlen_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_4_0",
						0
					],
					"source": [
						"pat_init_trig",
						56
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_4_0",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_4_1",
						0
					],
					"source": [
						"pat_init_trig",
						55
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_4_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_4_2",
						0
					],
					"source": [
						"pat_init_trig",
						54
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_4_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_4_3",
						0
					],
					"source": [
						"pat_init_trig",
						53
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_4_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_4_4",
						0
					],
					"source": [
						"pat_init_trig",
						52
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_4_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_4_5",
						0
					],
					"source": [
						"pat_init_trig",
						51
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_4_5",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_4_6",
						0
					],
					"source": [
						"pat_init_trig",
						50
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_4_6",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_patlen_4",
						0
					],
					"source": [
						"pat_init_trig",
						49
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_patlen_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_5_0",
						0
					],
					"source": [
						"pat_init_trig",
						48
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_5_0",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_5_1",
						0
					],
					"source": [
						"pat_init_trig",
						47
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_5_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_5_2",
						0
					],
					"source": [
						"pat_init_trig",
						46
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_5_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_5_3",
						0
					],
					"source": [
						"pat_init_trig",
						45
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_5_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_5_4",
						0
					],
					"source": [
						"pat_init_trig",
						44
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_5_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_5_5",
						0
					],
					"source": [
						"pat_init_trig",
						43
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_5_5",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_5_6",
						0
					],
					"source": [
						"pat_init_trig",
						42
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_5_6",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_patlen_5",
						0
					],
					"source": [
						"pat_init_trig",
						41
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_patlen_5",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_6_0",
						0
					],
					"source": [
						"pat_init_trig",
						40
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_6_0",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_6_1",
						0
					],
					"source": [
						"pat_init_trig",
						39
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_6_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_6_2",
						0
					],
					"source": [
						"pat_init_trig",
						38
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_6_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_6_3",
						0
					],
					"source": [
						"pat_init_trig",
						37
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_6_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_6_4",
						0
					],
					"source": [
						"pat_init_trig",
						36
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_6_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_6_5",
						0
					],
					"source": [
						"pat_init_trig",
						35
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_6_5",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_6_6",
						0
					],
					"source": [
						"pat_init_trig",
						34
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_6_6",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_patlen_6",
						0
					],
					"source": [
						"pat_init_trig",
						33
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_patlen_6",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_7_0",
						0
					],
					"source": [
						"pat_init_trig",
						32
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_7_0",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_7_1",
						0
					],
					"source": [
						"pat_init_trig",
						31
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_7_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_7_2",
						0
					],
					"source": [
						"pat_init_trig",
						30
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_7_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_7_3",
						0
					],
					"source": [
						"pat_init_trig",
						29
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_7_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_7_4",
						0
					],
					"source": [
						"pat_init_trig",
						28
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_7_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_7_5",
						0
					],
					"source": [
						"pat_init_trig",
						27
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_7_5",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_7_6",
						0
					],
					"source": [
						"pat_init_trig",
						26
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_7_6",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_7_7",
						0
					],
					"source": [
						"pat_init_trig",
						25
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_7_7",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_7_8",
						0
					],
					"source": [
						"pat_init_trig",
						24
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_7_8",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_patlen_7",
						0
					],
					"source": [
						"pat_init_trig",
						23
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_patlen_7",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_8_0",
						0
					],
					"source": [
						"pat_init_trig",
						22
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_8_0",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_8_1",
						0
					],
					"source": [
						"pat_init_trig",
						21
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_8_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_8_2",
						0
					],
					"source": [
						"pat_init_trig",
						20
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_8_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_8_3",
						0
					],
					"source": [
						"pat_init_trig",
						19
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_8_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_8_4",
						0
					],
					"source": [
						"pat_init_trig",
						18
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_8_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_8_5",
						0
					],
					"source": [
						"pat_init_trig",
						17
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_8_5",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_8_6",
						0
					],
					"source": [
						"pat_init_trig",
						16
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_8_6",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_8_7",
						0
					],
					"source": [
						"pat_init_trig",
						15
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_8_7",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_8_8",
						0
					],
					"source": [
						"pat_init_trig",
						14
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_8_8",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_patlen_8",
						0
					],
					"source": [
						"pat_init_trig",
						13
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_patlen_8",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_9_0",
						0
					],
					"source": [
						"pat_init_trig",
						12
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_9_0",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_9_1",
						0
					],
					"source": [
						"pat_init_trig",
						11
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_9_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_9_2",
						0
					],
					"source": [
						"pat_init_trig",
						10
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_9_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_9_3",
						0
					],
					"source": [
						"pat_init_trig",
						9
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_9_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_9_4",
						0
					],
					"source": [
						"pat_init_trig",
						8
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_9_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_9_5",
						0
					],
					"source": [
						"pat_init_trig",
						7
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_9_5",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_9_6",
						0
					],
					"source": [
						"pat_init_trig",
						6
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_9_6",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_9_7",
						0
					],
					"source": [
						"pat_init_trig",
						5
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_9_7",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_9_8",
						0
					],
					"source": [
						"pat_init_trig",
						4
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_9_8",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_9_9",
						0
					],
					"source": [
						"pat_init_trig",
						3
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_9_9",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_9_10",
						0
					],
					"source": [
						"pat_init_trig",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_9_10",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_step_9_11",
						0
					],
					"source": [
						"pat_init_trig",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_step_9_11",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_patlen_9",
						0
					],
					"source": [
						"pat_init_trig",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_bank",
						0
					],
					"source": [
						"msg_patlen_9",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"on_trig_1",
						0
					],
					"source": [
						"voice_ctrl_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_gate_on_1",
						0
					],
					"source": [
						"on_trig_1",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_gate_1",
						0
					],
					"source": [
						"msg_gate_on_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rand_pat_1",
						0
					],
					"source": [
						"on_trig_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_eq_1",
						0
					],
					"source": [
						"rand_pat_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_eq_1",
						1
					],
					"source": [
						"pat_last_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_dedup_1",
						0
					],
					"source": [
						"pat_eq_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_inc_1",
						0
					],
					"source": [
						"pat_dedup_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_mod_1",
						0
					],
					"source": [
						"pat_inc_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"cur_pat_1",
						0
					],
					"source": [
						"pat_mod_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"cur_pat_1",
						0
					],
					"source": [
						"pat_dedup_1",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_last_1",
						0
					],
					"source": [
						"cur_pat_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"cur_pat_i_1",
						0
					],
					"source": [
						"cur_pat_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_key_1",
						0
					],
					"source": [
						"cur_pat_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_fetch_1",
						0
					],
					"source": [
						"patlen_key_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_sub1_1",
						0
					],
					"source": [
						"patlen_fetch_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_setmax_1",
						0
					],
					"source": [
						"patlen_sub1_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_ctr_1",
						0
					],
					"source": [
						"patlen_setmax_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_gate_off_1",
						0
					],
					"source": [
						"voice_ctrl_1",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_gate_1",
						0
					],
					"source": [
						"msg_gate_off_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_ctr_1",
						3
					],
					"source": [
						"voice_ctrl_1",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"gate_obj_1",
						0
					],
					"source": [
						"step_gate_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"gate_obj_1",
						1
					],
					"source": [
						"metro_8th",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_ctr_1",
						0
					],
					"source": [
						"gate_obj_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_key_1",
						1
					],
					"source": [
						"step_ctr_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_key_1",
						0
					],
					"source": [
						"cur_pat_i_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_lookup_1",
						0
					],
					"source": [
						"step_key_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_sel_1",
						0
					],
					"source": [
						"step_lookup_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_ctr_1",
						0
					],
					"source": [
						"step_sel_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_key_1",
						0
					],
					"source": [
						"note_ctr_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_fetch_1",
						0
					],
					"source": [
						"note_key_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mtof_1",
						0
					],
					"source": [
						"note_fetch_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"on_trig_2",
						0
					],
					"source": [
						"voice_ctrl_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_gate_on_2",
						0
					],
					"source": [
						"on_trig_2",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_gate_2",
						0
					],
					"source": [
						"msg_gate_on_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rand_pat_2",
						0
					],
					"source": [
						"on_trig_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_eq_2",
						0
					],
					"source": [
						"rand_pat_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_eq_2",
						1
					],
					"source": [
						"pat_last_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_dedup_2",
						0
					],
					"source": [
						"pat_eq_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_inc_2",
						0
					],
					"source": [
						"pat_dedup_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_mod_2",
						0
					],
					"source": [
						"pat_inc_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"cur_pat_2",
						0
					],
					"source": [
						"pat_mod_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"cur_pat_2",
						0
					],
					"source": [
						"pat_dedup_2",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_last_2",
						0
					],
					"source": [
						"cur_pat_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"cur_pat_i_2",
						0
					],
					"source": [
						"cur_pat_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_key_2",
						0
					],
					"source": [
						"cur_pat_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_fetch_2",
						0
					],
					"source": [
						"patlen_key_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_sub1_2",
						0
					],
					"source": [
						"patlen_fetch_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_setmax_2",
						0
					],
					"source": [
						"patlen_sub1_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_ctr_2",
						0
					],
					"source": [
						"patlen_setmax_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_gate_off_2",
						0
					],
					"source": [
						"voice_ctrl_2",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_gate_2",
						0
					],
					"source": [
						"msg_gate_off_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_ctr_2",
						3
					],
					"source": [
						"voice_ctrl_2",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"gate_obj_2",
						0
					],
					"source": [
						"step_gate_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"gate_obj_2",
						1
					],
					"source": [
						"metro_8th",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_ctr_2",
						0
					],
					"source": [
						"gate_obj_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_key_2",
						1
					],
					"source": [
						"step_ctr_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_key_2",
						0
					],
					"source": [
						"cur_pat_i_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_lookup_2",
						0
					],
					"source": [
						"step_key_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_sel_2",
						0
					],
					"source": [
						"step_lookup_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_ctr_2",
						0
					],
					"source": [
						"step_sel_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_key_2",
						0
					],
					"source": [
						"note_ctr_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_fetch_2",
						0
					],
					"source": [
						"note_key_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mtof_2",
						0
					],
					"source": [
						"note_fetch_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"on_trig_3",
						0
					],
					"source": [
						"voice_ctrl_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_gate_on_3",
						0
					],
					"source": [
						"on_trig_3",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_gate_3",
						0
					],
					"source": [
						"msg_gate_on_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rand_pat_3",
						0
					],
					"source": [
						"on_trig_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_eq_3",
						0
					],
					"source": [
						"rand_pat_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_eq_3",
						1
					],
					"source": [
						"pat_last_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_dedup_3",
						0
					],
					"source": [
						"pat_eq_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_inc_3",
						0
					],
					"source": [
						"pat_dedup_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_mod_3",
						0
					],
					"source": [
						"pat_inc_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"cur_pat_3",
						0
					],
					"source": [
						"pat_mod_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"cur_pat_3",
						0
					],
					"source": [
						"pat_dedup_3",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_last_3",
						0
					],
					"source": [
						"cur_pat_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"cur_pat_i_3",
						0
					],
					"source": [
						"cur_pat_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_key_3",
						0
					],
					"source": [
						"cur_pat_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_fetch_3",
						0
					],
					"source": [
						"patlen_key_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_sub1_3",
						0
					],
					"source": [
						"patlen_fetch_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_setmax_3",
						0
					],
					"source": [
						"patlen_sub1_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_ctr_3",
						0
					],
					"source": [
						"patlen_setmax_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_gate_off_3",
						0
					],
					"source": [
						"voice_ctrl_3",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_gate_3",
						0
					],
					"source": [
						"msg_gate_off_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_ctr_3",
						3
					],
					"source": [
						"voice_ctrl_3",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"gate_obj_3",
						0
					],
					"source": [
						"step_gate_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"gate_obj_3",
						1
					],
					"source": [
						"metro_8th",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_ctr_3",
						0
					],
					"source": [
						"gate_obj_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_key_3",
						1
					],
					"source": [
						"step_ctr_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_key_3",
						0
					],
					"source": [
						"cur_pat_i_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_lookup_3",
						0
					],
					"source": [
						"step_key_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_sel_3",
						0
					],
					"source": [
						"step_lookup_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_ctr_3",
						0
					],
					"source": [
						"step_sel_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_key_3",
						0
					],
					"source": [
						"note_ctr_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_fetch_3",
						0
					],
					"source": [
						"note_key_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mtof_3",
						0
					],
					"source": [
						"note_fetch_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"on_trig_4",
						0
					],
					"source": [
						"voice_ctrl_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_gate_on_4",
						0
					],
					"source": [
						"on_trig_4",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_gate_4",
						0
					],
					"source": [
						"msg_gate_on_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rand_pat_4",
						0
					],
					"source": [
						"on_trig_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_eq_4",
						0
					],
					"source": [
						"rand_pat_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_eq_4",
						1
					],
					"source": [
						"pat_last_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_dedup_4",
						0
					],
					"source": [
						"pat_eq_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_inc_4",
						0
					],
					"source": [
						"pat_dedup_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_mod_4",
						0
					],
					"source": [
						"pat_inc_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"cur_pat_4",
						0
					],
					"source": [
						"pat_mod_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"cur_pat_4",
						0
					],
					"source": [
						"pat_dedup_4",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"pat_last_4",
						0
					],
					"source": [
						"cur_pat_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"cur_pat_i_4",
						0
					],
					"source": [
						"cur_pat_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_key_4",
						0
					],
					"source": [
						"cur_pat_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_fetch_4",
						0
					],
					"source": [
						"patlen_key_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_sub1_4",
						0
					],
					"source": [
						"patlen_fetch_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"patlen_setmax_4",
						0
					],
					"source": [
						"patlen_sub1_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_ctr_4",
						0
					],
					"source": [
						"patlen_setmax_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_gate_off_4",
						0
					],
					"source": [
						"voice_ctrl_4",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_gate_4",
						0
					],
					"source": [
						"msg_gate_off_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_ctr_4",
						3
					],
					"source": [
						"voice_ctrl_4",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"gate_obj_4",
						0
					],
					"source": [
						"step_gate_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"gate_obj_4",
						1
					],
					"source": [
						"metro_8th",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_ctr_4",
						0
					],
					"source": [
						"gate_obj_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_key_4",
						1
					],
					"source": [
						"step_ctr_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_key_4",
						0
					],
					"source": [
						"cur_pat_i_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_lookup_4",
						0
					],
					"source": [
						"step_key_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"step_sel_4",
						0
					],
					"source": [
						"step_lookup_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_ctr_4",
						0
					],
					"source": [
						"step_sel_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_key_4",
						0
					],
					"source": [
						"note_ctr_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"note_fetch_4",
						0
					],
					"source": [
						"note_key_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mtof_4",
						0
					],
					"source": [
						"note_fetch_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"start_rand_1",
						0
					],
					"source": [
						"step_sel_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"start_float_1",
						0
					],
					"source": [
						"start_rand_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_loopst_1",
						0
					],
					"source": [
						"start_float_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"groove_1",
						0
					],
					"source": [
						"msg_loopst_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"groove_1",
						0
					],
					"source": [
						"msg_loopdur_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_loopdur_1",
						0
					],
					"source": [
						"lb_loopdur_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"groove_1",
						1
					],
					"source": [
						"rate_line_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_div_1",
						0
					],
					"source": [
						"mtof_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_div_1",
						1
					],
					"source": [
						"ref_hz",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_pack_1",
						0
					],
					"source": [
						"rate_div_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_line_1",
						0
					],
					"source": [
						"rate_pack_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_vol_on_1",
						0
					],
					"source": [
						"voice_ctrl_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_env_1",
						0
					],
					"source": [
						"msg_vol_on_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_vol_off_1",
						0
					],
					"source": [
						"voice_ctrl_1",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_env_1",
						0
					],
					"source": [
						"msg_vol_off_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_vol_taper_1",
						0
					],
					"source": [
						"voice_ctrl_1",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_env_1",
						0
					],
					"source": [
						"msg_vol_taper_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_sig_1",
						0
					],
					"source": [
						"groove_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_sig_1",
						1
					],
					"source": [
						"vol_env_1",
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
						"vol_sig_1",
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
						"msg_pan_1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"start_rand_2",
						0
					],
					"source": [
						"step_sel_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"start_float_2",
						0
					],
					"source": [
						"start_rand_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_loopst_2",
						0
					],
					"source": [
						"start_float_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"groove_2",
						0
					],
					"source": [
						"msg_loopst_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"groove_2",
						0
					],
					"source": [
						"msg_loopdur_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_loopdur_2",
						0
					],
					"source": [
						"lb_loopdur_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"groove_2",
						1
					],
					"source": [
						"rate_line_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_div_2",
						0
					],
					"source": [
						"mtof_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_div_2",
						1
					],
					"source": [
						"ref_hz",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_pack_2",
						0
					],
					"source": [
						"rate_div_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_line_2",
						0
					],
					"source": [
						"rate_pack_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_vol_on_2",
						0
					],
					"source": [
						"voice_ctrl_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_env_2",
						0
					],
					"source": [
						"msg_vol_on_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_vol_off_2",
						0
					],
					"source": [
						"voice_ctrl_2",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_env_2",
						0
					],
					"source": [
						"msg_vol_off_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_vol_taper_2",
						0
					],
					"source": [
						"voice_ctrl_2",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_env_2",
						0
					],
					"source": [
						"msg_vol_taper_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_sig_2",
						0
					],
					"source": [
						"groove_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_sig_2",
						1
					],
					"source": [
						"vol_env_2",
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
						"vol_sig_2",
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
						"msg_pan_2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"start_rand_3",
						0
					],
					"source": [
						"step_sel_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"start_float_3",
						0
					],
					"source": [
						"start_rand_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_loopst_3",
						0
					],
					"source": [
						"start_float_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"groove_3",
						0
					],
					"source": [
						"msg_loopst_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"groove_3",
						0
					],
					"source": [
						"msg_loopdur_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_loopdur_3",
						0
					],
					"source": [
						"lb_loopdur_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"groove_3",
						1
					],
					"source": [
						"rate_line_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_div_3",
						0
					],
					"source": [
						"mtof_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_div_3",
						1
					],
					"source": [
						"ref_hz",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_pack_3",
						0
					],
					"source": [
						"rate_div_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_line_3",
						0
					],
					"source": [
						"rate_pack_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_vol_on_3",
						0
					],
					"source": [
						"voice_ctrl_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_env_3",
						0
					],
					"source": [
						"msg_vol_on_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_vol_off_3",
						0
					],
					"source": [
						"voice_ctrl_3",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_env_3",
						0
					],
					"source": [
						"msg_vol_off_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_vol_taper_3",
						0
					],
					"source": [
						"voice_ctrl_3",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_env_3",
						0
					],
					"source": [
						"msg_vol_taper_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_sig_3",
						0
					],
					"source": [
						"groove_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_sig_3",
						1
					],
					"source": [
						"vol_env_3",
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
						"vol_sig_3",
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
						"msg_pan_3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"start_rand_4",
						0
					],
					"source": [
						"step_sel_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"start_float_4",
						0
					],
					"source": [
						"start_rand_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_loopst_4",
						0
					],
					"source": [
						"start_float_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"groove_4",
						0
					],
					"source": [
						"msg_loopst_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"groove_4",
						0
					],
					"source": [
						"msg_loopdur_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_loopdur_4",
						0
					],
					"source": [
						"lb_loopdur_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"groove_4",
						1
					],
					"source": [
						"rate_line_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_div_4",
						0
					],
					"source": [
						"mtof_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_div_4",
						1
					],
					"source": [
						"ref_hz",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_pack_4",
						0
					],
					"source": [
						"rate_div_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"rate_line_4",
						0
					],
					"source": [
						"rate_pack_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_vol_on_4",
						0
					],
					"source": [
						"voice_ctrl_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_env_4",
						0
					],
					"source": [
						"msg_vol_on_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_vol_off_4",
						0
					],
					"source": [
						"voice_ctrl_4",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_env_4",
						0
					],
					"source": [
						"msg_vol_off_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"msg_vol_taper_4",
						0
					],
					"source": [
						"voice_ctrl_4",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_env_4",
						0
					],
					"source": [
						"msg_vol_taper_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_sig_4",
						0
					],
					"source": [
						"groove_4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"vol_sig_4",
						1
					],
					"source": [
						"vol_env_4",
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
						"vol_sig_4",
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
						"msg_pan_4",
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
						"pan_1",
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
						"pan_1",
						1
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
						"pan_2",
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
						"pan_2",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mix_L2",
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
						"mix_R2",
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
						"mix_L2",
						1
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
						"mix_R2",
						1
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
						"mix_L3",
						0
					],
					"source": [
						"mix_L2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mix_R3",
						0
					],
					"source": [
						"mix_R2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mix_L3",
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
						"mix_R3",
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
						"mix_dry_L",
						0
					],
					"source": [
						"mix_L3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mix_dry_R",
						0
					],
					"source": [
						"mix_R3",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"mix_dry_L",
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
						"mix_dry_R",
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
						"mix_dry_L",
						1
					],
					"source": [
						"click_gain",
						0
					],
					"order": 2
				}
			},
			{
				"patchline": {
					"destination": [
						"mix_dry_R",
						1
					],
					"source": [
						"click_gain",
						0
					],
					"order": 3
				}
			},
			{
				"patchline": {
					"destination": [
						"master_L",
						0
					],
					"source": [
						"mix_dry_L",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"master_R",
						0
					],
					"source": [
						"mix_dry_R",
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
						"master_L",
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
						"master_R",
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
				"bootpath": "~/Library/Application Support/Cycling '74/Max 8/Examples/spatialization/panning/lib",
				"patcherrelativepath": "../../../Library/Application Support/Cycling '74/Max 8/Examples/spatialization/panning/lib",
				"type": "JSON",
				"implicit": 1
			}
		],
		"autosave": 0
	}
}