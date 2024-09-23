"""Hash library for internal use in lightningcss."""

def sha256_ascii_printable_chars(message):
    """Computes the SHA256 hash of the given string and returns a hex string.

    Assumes that the message consists of only printable ASCII characters.
    All other bytes in the payload are substituted with 0x00.

    Args:
        message: the string to compute

    Returns:
        sha256 hash
    """

    # Initialize hash values
    H = [
        0x6a09e667,
        0xbb67ae85,
        0x3c6ef372,
        0xa54ff53a,
        0x510e527f,
        0x9b05688c,
        0x1f83d9ab,
        0x5be0cd19,
    ]

    # SHA256 constants
    K = [
        0x428a2f98,
        0x71374491,
        0xb5c0fbcf,
        0xe9b5dba5,
        0x3956c25b,
        0x59f111f1,
        0x923f82a4,
        0xab1c5ed5,
        0xd807aa98,
        0x12835b01,
        0x243185be,
        0x550c7dc3,
        0x72be5d74,
        0x80deb1fe,
        0x9bdc06a7,
        0xc19bf174,
        0xe49b69c1,
        0xefbe4786,
        0x0fc19dc6,
        0x240ca1cc,
        0x2de92c6f,
        0x4a7484aa,
        0x5cb0a9dc,
        0x76f988da,
        0x983e5152,
        0xa831c66d,
        0xb00327c8,
        0xbf597fc7,
        0xc6e00bf3,
        0xd5a79147,
        0x06ca6351,
        0x14292967,
        0x27b70a85,
        0x2e1b2138,
        0x4d2c6dfc,
        0x53380d13,
        0x650a7354,
        0x766a0abb,
        0x81c2c92e,
        0x92722c85,
        0xa2bfe8a1,
        0xa81a664b,
        0xc24b8b70,
        0xc76c51a3,
        0xd192e819,
        0xd6990624,
        0xf40e3585,
        0x106aa070,
        0x19a4c116,
        0x1e376c08,
        0x2748774c,
        0x34b0bcb5,
        0x391c0cb3,
        0x4ed8aa4a,
        0x5b9cca4f,
        0x682e6ff3,
        0x748f82ee,
        0x78a5636f,
        0x84c87814,
        0x8cc70208,
        0x90befffa,
        0xa4506ceb,
        0xbef9a3f7,
        0xc67178f2,
    ]

    MASK_32 = 0xffffffff

    # Helper functions
    def rotr(n, x):
        return ((x >> n) | (x << (32 - n))) & MASK_32

    def shr(n, x):
        return (x >> n) & MASK_32

    def ch(x, y, z):
        return (x & y) ^ ((~x) & z)

    def maj(x, y, z):
        return (x & y) ^ (x & z) ^ (y & z)

    def big_sigma0(x):
        return rotr(2, x) ^ rotr(13, x) ^ rotr(22, x)

    def big_sigma1(x):
        return rotr(6, x) ^ rotr(11, x) ^ rotr(25, x)

    def small_sigma0(x):
        return rotr(7, x) ^ rotr(18, x) ^ shr(3, x)

    def small_sigma1(x):
        return rotr(17, x) ^ rotr(19, x) ^ shr(10, x)

    # Pre-processing: Convert message to bytes
    m_bytes = _get_approx_bytes(message)

    # Append the '1' bit (0x80)
    m_bytes.append(0x80)

    # Calculate the number of zero bytes to pad
    mlen_bits = len(m_bytes) * 8  # Current message length in bits after appending '1' bit

    # Length modulo 512 bits
    k = mlen_bits % 512

    # Number of bits to reach 448 mod 512
    bits_to_pad = (448 - k) % 512

    # Number of zero bytes to pad
    n_zero_bytes = bits_to_pad // 8

    # Pad with zero bytes
    for _ in range(n_zero_bytes):
        m_bytes.append(0x00)

    # Append the original message length as a 64-bit big-endian integer
    length_bits = (len(m_bytes) - n_zero_bytes - 1) * 8  # Original message length in bits
    length_bytes = []
    for i in range(8):
        shift = (7 - i) * 8
        length_bytes.append((length_bits >> shift) & 0xff)
    m_bytes.extend(length_bytes)

    # Process the message in 512-bit chunks
    num_blocks = len(m_bytes) // 64
    for i in range(num_blocks):
        W = [0 for _ in range(64)]

        # Prepare the message schedule
        for t in range(16):
            idx = i * 64 + t * 4
            W[t] = (
                (m_bytes[idx] << 24) |
                (m_bytes[idx + 1] << 16) |
                (m_bytes[idx + 2] << 8) |
                (m_bytes[idx + 3])
            ) & MASK_32
        for t in range(16, 64):
            s0 = small_sigma0(W[t - 15])
            s1 = small_sigma1(W[t - 2])
            W[t] = (W[t - 16] + s0 + W[t - 7] + s1) & MASK_32

        # Initialize working variables
        a = H[0]
        b = H[1]
        c = H[2]
        d = H[3]
        e = H[4]
        f = H[5]
        g = H[6]
        h = H[7]

        # Main compression loop
        for t in range(64):
            T1 = (h + big_sigma1(e) + ch(e, f, g) + K[t] + W[t]) & MASK_32
            T2 = (big_sigma0(a) + maj(a, b, c)) & MASK_32
            h = g
            g = f
            f = e
            e = (d + T1) & MASK_32
            d = c
            c = b
            b = a
            a = (T1 + T2) & MASK_32

        # Update hash values
        H[0] = (H[0] + a) & MASK_32
        H[1] = (H[1] + b) & MASK_32
        H[2] = (H[2] + c) & MASK_32
        H[3] = (H[3] + d) & MASK_32
        H[4] = (H[4] + e) & MASK_32
        H[5] = (H[5] + f) & MASK_32
        H[6] = (H[6] + g) & MASK_32
        H[7] = (H[7] + h) & MASK_32

    # Produce the final hash value (big-endian)
    hash_bytes = []
    for h_val in H:
        for i in range(4):
            shift = (3 - i) * 8
            hash_bytes.append((h_val >> shift) & 0xff)

    # Convert to hexadecimal string
    hex_digits = "0123456789abcdef"
    hash_hex = ""
    for b in hash_bytes:
        hash_hex += hex_digits[(b >> 4) & 0xf]
        hash_hex += hex_digits[b & 0xf]

    return hash_hex

_ord_table = {
    " ": 32,
    "!": 33,
    '"': 34,
    "#": 35,
    "$": 36,
    "%": 37,
    "&": 38,
    "'": 39,
    "(": 40,
    ")": 41,
    "*": 42,
    "+": 43,
    ",": 44,
    "-": 45,
    ".": 46,
    "/": 47,
    "0": 48,
    "1": 49,
    "2": 50,
    "3": 51,
    "4": 52,
    "5": 53,
    "6": 54,
    "7": 55,
    "8": 56,
    "9": 57,
    ":": 58,
    ";": 59,
    "<": 60,
    "=": 61,
    ">": 62,
    "?": 63,
    "@": 64,
    "A": 65,
    "B": 66,
    "C": 67,
    "D": 68,
    "E": 69,
    "F": 70,
    "G": 71,
    "H": 72,
    "I": 73,
    "J": 74,
    "K": 75,
    "L": 76,
    "M": 77,
    "N": 78,
    "O": 79,
    "P": 80,
    "Q": 81,
    "R": 82,
    "S": 83,
    "T": 84,
    "U": 85,
    "V": 86,
    "W": 87,
    "X": 88,
    "Y": 89,
    "Z": 90,
    "[": 91,
    "\\": 92,
    "]": 93,
    "^": 94,
    "_": 95,
    "`": 96,
    "a": 97,
    "b": 98,
    "c": 99,
    "d": 100,
    "e": 101,
    "f": 102,
    "g": 103,
    "h": 104,
    "i": 105,
    "j": 106,
    "k": 107,
    "l": 108,
    "m": 109,
    "n": 110,
    "o": 111,
    "p": 112,
    "q": 113,
    "r": 114,
    "s": 115,
    "t": 116,
    "u": 117,
    "v": 118,
    "w": 119,
    "x": 120,
    "y": 121,
    "z": 122,
    "{": 123,
    "|": 124,
    "}": 125,
    "~": 126,
}

def _get_approx_bytes(s):
    return [_ord_table.get(c, 0) for c in s.elems()]
