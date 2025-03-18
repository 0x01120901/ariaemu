function print(_str) {
    show_debug_message(_str);
}

function op2str(_op) {
    switch(_op) {
        case 0x00: return "NOOP";
        default: return $"MISSING {_op}";
    }
}