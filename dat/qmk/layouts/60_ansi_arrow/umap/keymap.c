/* qmk/layouts/60_ansi_arrow/umap/keymap.c ::*/

/*  tap layer: escape, slash
    layer 1: f-keys, arrows, pgup, pgdn, end, home, del
    layer 2: mouse
    layer 3: rgb, boot */

#include QMK_KEYBOARD_H

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    /* base ::
    ,-----------------------------------------------------------.
    | ` | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 | - | = |BSpace |
    |-----------------------------------------------------------|
    | Tab | Q | W | E | R | T | Y | U | I | O | P | [ | ] |  \  |
    |-----------------------------------------------------------|
    | Ctrl | A | S | D | F | G | H | J | K | L | ; | ' | Enter  |
    |-----------------------------------------------------------|
    | Shift  | Z | X | C | V | B | N | M | , | . |Shift |Up |Del|
    |-----------------------------------------------------------|
    |Ctrl|Win |Alt |         Space          |Fn1|Fn2|Lft|Dwn|Rgt|
    `-----------------------------------------------------------'
    // base (tap) ::
    ,-----------------------------------------------------------.
    |   |   |   |   |   |   |   |   |   |   |   |   |   |       |
    |-----------------------------------------------------------|
    |     |   |   |   |   |   |   |   |   |   |   |   |   |     |
    |-----------------------------------------------------------|
    | Esc  |   |   |   |   |   |   |   |   |   |   |   |        |
    |-----------------------------------------------------------|
    |        |   |   |   |   |   |   |   |   |   |  /   |   |   |
    |-----------------------------------------------------------|
    |    |    |    |                        |   |   |   |   |   |
    `-----------------------------------------------------------'*/
    [0] = LAYOUT(
        QK_GESC,        KC_1,    KC_2,            KC_3,    KC_4,    KC_5,    KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS,         KC_EQL,  KC_BSPC,
        KC_TAB,         KC_Q,    KC_W,            KC_E,    KC_R,    KC_T,    KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_LBRC,         KC_RBRC, KC_BSLS,
        CTL_T(KC_CAPS), KC_A,    KC_S,            KC_D,    KC_F,    KC_G,    KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT,                  KC_ENT,
        KC_LSFT,                 KC_Z,            KC_X,    KC_C,    KC_V,    KC_B,    KC_N,    KC_M,    KC_COMM, KC_DOT,  RSFT_T(KC_SLSH), KC_UP,   KC_DEL,
        KC_LCTL,        KC_LGUI, KC_LALT,                                    KC_SPC,                    MO(1),   MO(2),   KC_LEFT,         KC_DOWN, KC_RGHT
    ),

    /* function ::
    ,-----------------------------------------------------------.
    | ~ |F1 |F2 |F3 |F4 |F5 |F6 |F7 |F8 |F9 |F10|F11|F12|  Del  |
    |-----------------------------------------------------------|
    |  ~  | ~ | ~ |End| ~ | ~ | ~ |PgU| ~ | ~ | ~ | ~ | ~ | Tg3 |
    |-----------------------------------------------------------|
    |      |Hom| ~ |PgD|PgD| ~ |Lft|Dwn|Up |Rgt| ~ | ~ |        |
    |-----------------------------------------------------------|
    |        | ~ |Del| ~ | ~ |PgU| ~ | ~ | ~ | ~ |      | ~ | ~ |
    |-----------------------------------------------------------|
    |     |    |    |          ~            | ~ | ~ | ~ | ~ | ~ |
    `-----------------------------------------------------------'*/
    [1] = LAYOUT(
        KC_NO,   KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,  KC_F12,  KC_DEL,
        KC_NO,   KC_NO,   KC_NO,   KC_END,  KC_NO,   KC_NO,   KC_NO,   KC_PGUP, KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   TG(3),
        _______, KC_HOME, KC_NO,   KC_PGDN, KC_PGDN, KC_NO,   KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, KC_NO,   KC_NO,            _______,
        _______,          KC_NO,   KC_DEL,  KC_NO,   KC_NO,   KC_PGUP, KC_NO,   KC_NO,   KC_NO,   KC_NO,   _______, KC_NO,   KC_NO,
        _______, _______, _______,                            KC_NO,                     KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO
    ),

    /* mouse ::
    ,-----------------------------------------------------------.
    | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ |   ~   |
    |-----------------------------------------------------------|
    |  ~  | ~ | ~ |Msu| ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ |  ~  |
    |-----------------------------------------------------------|
    |      | ~ |MsL|MsD|MsL| ~ | ~ |MWD|MSU| ~ | ~ | ~ |        |
    |-----------------------------------------------------------|
    |        | ~ | ~ | ~ | ~ | ~ | ~ |Ms1|Ms3|Ms2|      | ~ | ~ |
    |-----------------------------------------------------------|
    |     |    |    |          ~            | ~ | ~ | ~ | ~ | ~ |
    `-----------------------------------------------------------'*/
    [2] = LAYOUT(
        KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,
        KC_NO,   KC_NO,   KC_NO,   KC_MS_U, KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,
        _______, KC_NO,   KC_MS_L, KC_MS_D, KC_MS_R, KC_NO,   KC_NO,   KC_WH_D, KC_WH_U, KC_NO,   KC_NO,   KC_NO,            _______,
        _______,          KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_BTN1, KC_BTN3, KC_BTN2, _______, KC_NO,   KC_NO,
        _______, _______, _______,                            KC_NO,                     KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO
    ),

    /* keyboard ::
    ,-----------------------------------------------------------.
    |Bt | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ |VaD|VaI|Toggle |
    |-----------------------------------------------------------|
    |  ~  | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ |HuD|HuI|Mode |
    |-----------------------------------------------------------|
    | Tg3  | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ |SaD|SaI|   ~    |
    |-----------------------------------------------------------|
    |    ~   | ~ | ~ | ~ | ~ | ~ | ~ | ~ |SpD|SpI|  ~   | ~ | ~ |
    |-----------------------------------------------------------|
    | ~  | ~  | ~  |           ~            | ~ | ~ | ~ | ~ | ~ |
    `-----------------------------------------------------------'*/
    [3] = LAYOUT(
        QK_BOOT, KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   RGB_VAD, RGB_VAI, RGB_TOG,
        KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   RGB_HUD, RGB_HUI, RGB_MOD,
        TG(3),   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   RGB_SAD, RGB_SAI,          KC_NO,
        KC_NO,            KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   RGB_SPD, RGB_SPI, KC_NO,   KC_NO,   KC_NO,
        KC_NO,   KC_NO,   KC_NO,                              KC_NO,                     KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO
    )
};
