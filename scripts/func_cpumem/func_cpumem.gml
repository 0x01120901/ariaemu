#macro NO_OP 0x00

#macro FLAG_ZERO  0x80
#macro FLAG_SUB   0x40
#macro FLAG_HALF_CARRY 0x20
#macro FLAG_CARRY 0x10

function GB_CPU(_mem) constructor {
    A = 0;
    F = 0;
    B = 0; C = 0;
    D = 0; E = 0;
    H = 0; L = 0;
    SP = 0;
    PC = 0;
    
    memory = _mem;
    
    function set_flag(_fl) { F = _fl ? (F|_fl) : (F&~_fl); }
    function memory_read(_addr) { return memory.read(_addr); }
    function memory_write(_addr, _val) { return memory.write(_addr, _val); }
    
    function execute(_opcode) {
        switch(_opcode) {
            case NO_OP: // NOOP
                break;
            
            case 0x06:
                B = memory_read(PC++);
                break;
            case 0x0E:
                C = memory_read(PC++);
                break;
            case 0x16:
                D = memory_read(PC++);
                break;
            case 0x1E:
                E = memory_read(PC++);
                break;
            
            case 0x80: A = (A+B)&0xFF;
        }
    }
    
    function update() { 
        var opcode = memory_read(PC++);
        execute(opcode);
        
        print($"PC: {PC} OP: {opcode}");
    }
}

function GB_MEM() constructor {
    rom = array_create(0x8000, 0);
    vram = array_create(0x2000, 0);
    ram = array_create(0x2000, 0);

    function read(_addr) {
        if (_addr < 0x8000)
            return rom[_addr];
    }

    function write(_addr, _val) {
    }
}

function load_rom(_fn) {
    var buf = buffer_load(_fn);
    var size = buffer_get_size(buf);
    
    for (var i = 0; i < min(size, array_length(rom)); i++) {
        rom[i] = buffer_read(buffer, buffer_u8);
    }

    buffer_delete(buffer);
    
    cpu.PC = 0x0100;
    
    return 0;
}