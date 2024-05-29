library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- opcodes possíveis
-- I - 0  0  0  0  0     0  0  0  0      0  0  0  0      0  0  0
--    |  constante  |   |registrador|    | destino  |    |opcode|
--
-- R - 0  0  0  0      0  0  0  0      0  0  0  0     0     0  0  0
--    |    r2    |    |    r1    |    |  destino |  |soma| |opcode|
--
-- B - 0  0  0  0  0     0  0  0  0      0  0  0  0      0  0  0
--    |constante    |   |   r2    |     |    r1   |      |opcode| 

-- 000 - imediatos soma
-- 001 - imediatos sub
-- 010 - lw, salvar constante
-- 011 (soma = 0) - registradores subtracao
-- 011 (soma = 1) - registradores soma
-- 100 - Branch if equal (com constante)
-- 101 - Branch if equal (com registradores)
-- 110 - Branch para endereco (constante)
-- 111 - Branch relativo (constante)

entity opcodedecoder is
    port(
        instrucao : in unsigned(15 downto 0);
        soma : out std_logic := '0';
        somaimediata : out std_logic := '0';
        subtracao : out std_logic := '0';
        subtracaoimediata : out std_logic := '0';
        cargaconstante : out std_logic := '0';
        beqconstante : out std_logic := '0';
        beqregistradores : out std_logic := '0';
        branchparaendereco : out std_logic := '0';
        branchrelativo : out std_logic := '0';

        registradordestino : out unsigned(3 downto 0) := "0000";
        registrador1 : out unsigned(3 downto 0) := "0000";
        registrador2 : out unsigned(3 downto 0) := "0000";
        constante : out unsigned(4 downto 0) := "00000"

    );
end entity;

architecture a_opcodedecoder of opcodedecoder is
    signal registradorop : std_logic;
    signal opcodepart : unsigned(2 downto 0);
    signal soma_signal : std_logic;
    signal somaimediata_signal : std_logic;
    signal subtracao_signal : std_logic;
    signal subtracaoimediata_signal : std_logic;
    signal cargaconstante_signal : std_logic;
    signal beqconstante_signal : std_logic;
    signal beqregistradores_signal : std_logic;
    signal branchparaendereco_signal : std_logic;
    signal branchrelativo_signal : std_logic;
    signal registradordestino_signal : unsigned(3 downto 0);
    signal registrador1_signal : unsigned(3 downto 0);
    signal registrador2_signal : unsigned(3 downto 0);
    signal constante_signal : unsigned(4 downto 0);

    signal tipoI : std_logic := '0';
    signal tipoR : std_logic := '0';
    signal tipoB : std_logic := '0';

    begin
        opcodepart <= instrucao(2 downto 0);
        registradorop <= instrucao(3);

        tipoR <= '1' when opcodepart = "011" else '0';
        tipoI <= '1' when opcodepart = "000" or opcodepart = "001" or opcodepart = "010"  else '0';
        tipoB <= '1' when opcodepart = "100" or opcodepart = "101" or opcodepart = "110" or opcodepart = "111" else '0';

        soma_signal <= '1' when opcodepart = "011" and registradorop = '1' else '0';
        subtracao_signal <= '1' when opcodepart = "011" and registradorop = '0' else '0';

        somaimediata_signal <= '1' when opcodepart = "000" else '0';
        subtracaoimediata_signal <= '1' when opcodepart = "001" else '0';

        cargaconstante_signal <= '1' when opcodepart = "010" else '0';

        beqconstante_signal <= '1' when opcodepart = "100" else '0';
        beqregistradores_signal <= '1' when opcodepart = "101" else '0';
        branchparaendereco_signal <= '1' when opcodepart = "110" else '0';
        branchrelativo_signal <= '1' when opcodepart = "111" else '0';

        registradordestino_signal <=    instrucao(7 downto 4) when tipoR = '1' else --se for soma
                                        instrucao(6 downto 3) when tipoI = '1' else -- se não for branch nem soma
                                        "0000";

        registrador1_signal <=          instrucao(11 downto 8) when tipoR = '1' else  -- se for op com regs
                                        instrucao(10 downto 7) when tipoI = '1' else  -- se for imediato
                                        instrucao(6 downto 3) when tipoB = '1' else   -- se branch
                                        "0000";

        registrador2_signal <=          instrucao(15 downto 12) when tipoR = '1' else
                                        instrucao(10 downto 7) when tipoB = '1' else
                                        "0000";
        constante_signal <=             instrucao(15 downto 11) when tipoI = '1' or tipoB = '1' else
                                        "00000";

    soma <= soma_signal;
    subtracao <= subtracao_signal;

    somaimediata <= somaimediata_signal;
    subtracaoimediata <= subtracaoimediata_signal;

    cargaconstante <= cargaconstante_signal;
    beqconstante <= beqconstante_signal;
    beqregistradores <= beqregistradores_signal;
    branchparaendereco <= branchparaendereco_signal;
    branchrelativo <= branchrelativo_signal;

    registradordestino <= registradordestino_signal;
    registrador1 <= registrador1_signal;
    registrador2 <= registrador2_signal;
    constante <= constante_signal;

end architecture;