/* qmk/layouts/60_ansi/umap1/keymap.c ::*/

/*  tap layer: escape, arrows
    layer 1: mouse, f-keys, arrows, pgup, pgdn, end, home, del
    layer 2: rgb, boot */

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
    | Shift  | Z | X | C | V | B | N | M | , | . | / |  Shift   |
    |-----------------------------------------------------------|
    |Ctrl|Win |Alt |         Space          |Alt | Fn |Win |Ctrl|
    `-----------------------------------------------------------'
    // base (tap) ::
    ,-----------------------------------------------------------.
    |   |   |   |   |   |   |   |   |   |   |   |   |   |       |
    |-----------------------------------------------------------|
    |     |   |   |   |   |   |   |   |   |   |   |   |   |     |
    |-----------------------------------------------------------|
    | Esc  |   |   |   |   |   |   |   |   |   |   |   |        |
    |-----------------------------------------------------------|
    |        |   |   |   |   |   |   |   |   |   |   |    Up    |
    |-----------------------------------------------------------|
    |    |    |    |                        |    |Left|Down|Rght|
    `-----------------------------------------------------------'*/
    [0] = LAYOUT_60_ansi(
        KC_GRV,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,    KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS, KC_EQL,  KC_BSPC,
        KC_TAB,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,    KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_LBRC, KC_RBRC, KC_BSLS,
        LCTL_T(KC_ESC),   KC_A,    KC_S,    KC_D,    KC_F,    KC_G,    KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT, KC_ENT,
        KC_LSFT,          KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,    KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH,          RSFT_T(KC_UP),
        KC_LCTL, KC_LGUI, KC_LALT,                            KC_SPC,           KC_RALT, LT(1,KC_LEFT),    RGUI_T(KC_DOWN),  RCTL_T(KC_RGHT)
    ),

    /* function ::
    ,-----------------------------------------------------------.
    | ~ |F1 |F2 |F3 |F4 |F5 |F6 |F7 |F8 |F9 |F10|F11|F12|  Del  |
    |-----------------------------------------------------------|
    |  ~  | ~ | ~ |Msu| ~ |Hom| ~ | ~ | ~ | ~ |PgU| ~ | ~ | Tg2 |
    |-----------------------------------------------------------|
    |      | ~ |MsL|MsD|MsL| ~ |Lft|Dwn|Up |Rgt|MWU| ~ |        |
    |-----------------------------------------------------------|
    |        | ~ |Del| ~ | ~ |End|PgD|Ms1|Ms3|Ms2|MWD|          |
    |-----------------------------------------------------------|
    |     |    |    |          ~            |    | ~  |    |    |
    `-----------------------------------------------------------'*/
    [1] = LAYOUT_60_ansi(
        KC_NO,   KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,  KC_F12,  KC_DEL,
        KC_NO,   KC_NO,   KC_NO,   KC_MS_U, KC_NO,   KC_HOME, KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_PGUP, KC_NO,   KC_NO,   TG(2),
        _______, KC_NO,   KC_MS_L, KC_MS_D, KC_MS_R, KC_NO,   KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, KC_WH_U, KC_NO,            _______,
        _______,          KC_NO,   KC_DEL,  KC_NO,   KC_NO,   KC_END,  KC_PGDN, KC_BTN1, KC_BTN3, KC_BTN2, KC_WH_D,          _______,
        _______, _______, _______,                            KC_NO,                              _______, KC_NO,   _______, _______
    ),

    /* keyboard ::
    ,-----------------------------------------------------------.
    |Bt | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ |VaD|VaI|Toggle |
    |-----------------------------------------------------------|
    |  ~  | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ |HuD|HuI|Mode |
    |-----------------------------------------------------------|
    | Tg2  | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ | ~ |SaD|SaI|   ~    |
    |-----------------------------------------------------------|
    |    ~   | ~ | ~ | ~ | ~ | ~ | ~ | ~ |SpD|SpI| ~ |    ~     |
    |-----------------------------------------------------------|
    | ~  | ~  | ~  |           ~            | ~  | ~  | ~  | ~  |
    `-----------------------------------------------------------'*/
    [2] = LAYOUT_60_ansi(
        QK_BOOT, KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   RGB_VAD, RGB_VAI, RGB_TOG,
        KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   RGB_HUD, RGB_HUI, RGB_MOD,
        TG(2),   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   RGB_SAD, RGB_SAI,          KC_NO,
        KC_NO,            KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   RGB_SPD, RGB_SPI, KC_NO,            KC_NO,
        KC_NO,   KC_NO,   KC_NO,                              KC_NO,                              KC_NO,   KC_NO,   KC_NO,   KC_NO
    )
};
