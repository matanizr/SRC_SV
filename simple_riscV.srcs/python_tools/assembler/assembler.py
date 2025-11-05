# -*- coding: utf-8 -*-
file_path   = r"C:\Users\roeis\OneDrive\שולחן העבודה\first_comp.txt"   # קלט אסמבלי
output_path = r"C:\Users\roeis\OneDrive\שולחן העבודה\output_hex.hex"   # פלט HEX

import re

# ====== token ======
def tokenize(line: str):
    # מסיר תגובות (; או #) ומפצל ע"פ פסיקים או רווחים
    line = line.split(';', 1)[0].split('#', 1)[0].strip()
    if not line:
        return []
    return [t for t in re.split(r'[,\s]+', line) if t]

# ====== עזר לרגיסטר / Immediate ======
def reg_num(tok: str) -> int:
    return int(tok.lower().lstrip('r'))

def parse_imm(val: str) -> int:
    """מפענח immediate בכל פורמט: decimal / 0xhex / 0bbin / 0ooct"""
    return int(val.strip(), 0)

# ======  opcode ======
MNEMONIC_TO_OPCODE = {
    # R-type
    'add': 12, 'sub': 14, 'and': 20, 'or': 22,
    # branch (opcode=8)
    'br': 8, 'brzr': 8, 'brnz': 8, 'brpl': 8, 'brmi': 8,
    # branch+link (opcode=9)
    'brl': 9, 'brlnv': 9, 'brlzr': 9, 'brlnz': 9, 'brlpl': 9, 'brlmi': 9,
    # immediate/c2
    'ld': 1, 'st': 3, 'la': 5, 'addi': 13, 'andi': 21, 'ori': 23,
    # PC-relative
    'ldr': 2, 'str': 4, 'lar': 6,
    # unary
    'neg': 15, 'not': 24,
    # control
    'stop': 31, 'nop': 0,
    # shifts
    'shr': 26, 'shra': 27, 'shl': 28, 'shc': 29,
}

def map_opcodes(first_words):
    return [(w, MNEMONIC_TO_OPCODE.get(w.lower())) for w in first_words]

# ====== Encoders ======

# --- R-type: [31:27]=op, [26:22]=ra, [21:17]=rb, [16:12]=rc, [11:0]=0 ---
def _encode_r3(tokens, opcode, name):
    # tokens לדוגמה: ['add','r5','r6','r7']
    if tokens[0].lower() == name:
        tokens = tokens[1:]
    ra, rb, rc = reg_num(tokens[0]), reg_num(tokens[1]), reg_num(tokens[2])
    word = ((opcode & 0x1F) << 27) | ((ra & 0x1F) << 22) | ((rb & 0x1F) << 17) | ((rc & 0x1F) << 12)
    return f"{word:032b}"

def encode_add32(tokens): return _encode_r3(tokens, 12, 'add')
def encode_sub32(tokens): return _encode_r3(tokens, 14, 'sub')
def encode_and32(tokens): return _encode_r3(tokens, 20, 'and')
def encode_or32 (tokens): return _encode_r3(tokens, 22, 'or')

# --- Branch (opcode=8):
# [31:27]=op(8), [26:22]=unused, [21:17]=rb, [16:12]=rc, [11:3]=0, [2:0]=cond
def encode_branch32(tokens):
    name = tokens[0].lower()
    COND = {'br':1, 'brzr':2, 'brnz':3, 'brpl':4, 'brmi':5}
    cond = COND[name]
    opcode = 8

    # תמיכה גם ב-"brzr r3,r4"
    ops = tokens[1:]
    if len(ops) == 1 and ',' in ops[0]:
        ops = [t for t in re.split(r'[,\s]+', ops[0]) if t]

    rb = reg_num(ops[0])
    rc = reg_num(ops[1]) if name != 'br' else 0

    word = ((opcode & 0x1F) << 27) | ((rb & 0x1F) << 17) | ((rc & 0x1F) << 12) | (cond & 0x7)
    return f"{word:032b}"

# --- Branch+Link (opcode=9):
# [31:27]=op(9), [26:22]=ra, [21:17]=rb, [16:12]=rc, [11:3]=0, [2:0]=cond
def encode_brl32(tokens):
    name = tokens[0].lower()
    COND = {'brlnv':0, 'brl':1, 'brlzr':2, 'brlnz':3, 'brlpl':4, 'brlmi':5}
    cond = COND[name]
    opcode = 9

    ops = tokens[1:]
    if len(ops) >= 1 and any(ch in ops[-1] for ch in ',()'):
        ops = [t for t in re.split(r'[,\s]+', " ".join(ops)) if t]

    ra = reg_num(ops[0]) if len(ops) >= 1 else 0
    rb = reg_num(ops[1]) if len(ops) >= 2 else 0
    rc = reg_num(ops[2]) if len(ops) >= 3 else 0

    word = ((opcode & 0x1F) << 27) | ((ra & 0x1F) << 22) | ((rb & 0x1F) << 17) | ((rc & 0x1F) << 12) | (cond & 0x7)
    return f"{word:032b}"

# --- Immediate/c2 family: ld/st/la/addi/andi/ori
# פורמט: [31:27]=op, [26:22]=ra, [21:17]=rb, [16:0]=c2
_MEM_IDX = re.compile(r'^\s*(-?\w+)\s*\(\s*(r\d+)\s*\)\s*$')  # תומך גם בהקס

def encode_imm_c2(tokens, opcode):
    """
    ld/st/la  : <mnemonic> ra, c2        | או: <mnemonic> ra, c2(rb)
    addi/andi/ori : <mnemonic> ra, rb, imm
    """
    name = tokens[0].lower()

    # ----- ADDI / ANDI / ORI -----
    if name in ('addi', 'andi', 'ori'):
        ra = reg_num(tokens[1])   # rd
        rb = reg_num(tokens[2])   # rs
        imm = parse_imm(tokens[3])  # תומך 0x.. / 0b.. / 0o.. / dec
        word = ((opcode & 0x1F) << 27) | ((ra & 0x1F) << 22) | ((rb & 0x1F) << 17) | (imm & 0x1FFFF)
        return f"{word:032b}"

    # ----- LD / ST / LA -----
    ra = reg_num(tokens[1])
    s  = " ".join(tokens[2:]).strip()

    m = _MEM_IDX.match(s)
    if m:
        c2 = parse_imm(m.group(1))
        rb = reg_num(m.group(2))
    else:
        # אם זה רגיסטר בודד – זו שגיאה (צריך מספר)
        if re.fullmatch(r'r\d+', s, flags=re.IGNORECASE):
            raise ValueError(f"{name}: האופרנד השני חייב להיות c2 או c2(rb), לא רגיסטר ('{s}')")
        c2 = parse_imm(s.strip().strip(','))
        rb = 0

    word = ((opcode & 0x1F) << 27) | ((ra & 0x1F) << 22) | ((rb & 0x1F) << 17) | (c2 & 0x1FFFF)
    return f"{word:032b}"

# --- PC-relative family: ldr / str / lar
# פורמט ביטים:
# [31:27] = opcode
# [26:22] = ra
# [21:0]  = c1
def encode_pc_relative(tokens, opcode):
    ra = reg_num(tokens[1])
    c1 = parse_imm(tokens[2])
    word = ((opcode & 0x1F) << 27) | ((ra & 0x1F) << 22) | (c1 & 0x3FFFFF)
    return f"{word:032b}"

# --- Unary ops (neg / not)
# [31:27] = OPCODE, [26:22] = RA, [21:17] = UNUSED, [16:12] = RC, [11:0] = UNUSED
def encode_unary(tokens, opcode):
    ra = reg_num(tokens[1])
    rc = reg_num(tokens[2])
    word = ((opcode & 0x1F) << 27) | ((ra & 0x1F) << 22) | ((rc & 0x1F) << 12)
    return f"{word:032b}"

# --- Shifts: shr/shra/shl/shc
# A: [31:27]=op, [26:22]=ra, [21:17]=rb, [16:0]=c3
# B: [31:27]=op, [26:22]=ra, [21:17]=rb, [16:12]=rc, [11:0]=0
def encode_shift(tokens, opcode):
    ra = reg_num(tokens[1])
    rb = reg_num(tokens[2])
    t3 = tokens[3].strip().lower()

    if re.fullmatch(r'r\d+', t3):
        rc = reg_num(t3)
        word = ((opcode & 0x1F) << 27) | ((ra & 0x1F) << 22) | ((rb & 0x1F) << 17) | ((rc & 0x1F) << 12)
        return f"{word:032b}"

    c3 = parse_imm(t3)
    if (c3 & 0x1F) == 0:
        raise ValueError(f"shift count (c3) חייב להיות ≠ 0 ב-5 ה-LSB (קיבלתי {t3})")
    word = ((opcode & 0x1F) << 27) | ((ra & 0x1F) << 22) | ((rb & 0x1F) << 17) | (c3 & 0x1FFFF)
    return f"{word:032b}"

# --- Control: stop / nop
def encode_control(tokens, opcode):
    word = (opcode & 0x1F) << 27
    return f"{word:032b}"

# ====== דיספאצ'ר ======
ENCODERS = {
    12: encode_add32,
    14: encode_sub32,
    20: encode_and32,
    22: encode_or32,
    8:  encode_branch32,   # br*
    9:  encode_brl32,      # brl*
}
def _wrap_imm(op):   return lambda tokens, _op=op: encode_imm_c2(tokens, _op)
def _wrap_pc(op):    return lambda tokens, _op=op: encode_pc_relative(tokens, _op)
def _wrap_unary(op): return lambda tokens, _op=op: encode_unary(tokens, _op)
def _wrap_shift(op): return lambda tokens, _op=op: encode_shift(tokens, _op)
def _wrap_ctrl(op):  return lambda tokens, _op=op: encode_control(tokens, _op)

# immediate/c2: ld/st/la/addi/andi/ori
for name in ('ld','st','la','addi','andi','ori'):
    ENCODERS[ MNEMONIC_TO_OPCODE[name] ] = _wrap_imm( MNEMONIC_TO_OPCODE[name] )

# PC-relative: ldr/str/lar
for name in ('ldr','str','lar'):
    ENCODERS[ MNEMONIC_TO_OPCODE[name] ] = _wrap_pc( MNEMONIC_TO_OPCODE[name] )

# Unary: neg/not
for name in ('neg','not'):
    ENCODERS[ MNEMONIC_TO_OPCODE[name] ] = _wrap_unary( MNEMONIC_TO_OPCODE[name] )

# Shifts: shr/shra/shl/shc
for name in ('shr','shra','shl','shc'):
    ENCODERS[ MNEMONIC_TO_OPCODE[name] ] = _wrap_shift( MNEMONIC_TO_OPCODE[name] )

# Control: stop/nop
for name in ('stop','nop'):
    ENCODERS[ MNEMONIC_TO_OPCODE[name] ] = _wrap_ctrl( MNEMONIC_TO_OPCODE[name] )

def encode_instruction(opcode, tokens):
    enc = ENCODERS.get(opcode)
    return enc(tokens) if enc else None

# ======reea encode and save ======
def main():
    first_words = []
    line_tokens = []
    with open(file_path, 'r', encoding='utf-8') as f:
        for line in f:
            toks = tokenize(line)
            if not toks:
                continue
            first_words.append(toks[0])
            line_tokens.append(toks)

    opcode_list = map_opcodes(first_words)

    encoded_bin = []
    for i, (name, opcode) in enumerate(opcode_list):
        if opcode is None:
            raise ValueError(f"Opcode לא ידוע לפקודה: {name} (שורה {i+1})")
        try:
            out = encode_instruction(opcode, line_tokens[i])
        except Exception as e:
            raise ValueError(f"שגיאה בקידוד בשורה {i+1}: {line_tokens[i]} -> {e}")
        if out is None:
            raise ValueError(f"לא נמצא encoder ל-opcode {opcode} (שורה {i+1})")
        encoded_bin.append(out)


    with open(output_path, 'w', encoding='utf-8') as f:
        for b in encoded_bin:
            hex8 = format(int(b, 2), '08X')  # 32-bit → 8 hex chars
            f.write(hex8 + "\n")

    print("✅ נשמר בהצלחה:")

if __name__ == "__main__":
    main()
