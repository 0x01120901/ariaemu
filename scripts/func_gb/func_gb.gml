function gb_init() {
    mem = new GB_MEM();
    cpu = new GB_CPU(mem);
}

function gb_step() {
    cpu.update();
}