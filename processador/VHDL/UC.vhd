library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- opcodes possíveis
-- I - 0  0  0  0  0  0  0      0  0  0         0  0  0        0  0  0
--    |      constante    |   |registrador|    | destino  |    |opcode|
--
-- R -   0    000    0  0  0        0  0  0       0  0  0      0  0  0
--    |soma|        |  r2   |      |   r1  |    |  destino |   |opcode|
--
-- B - 0  0  0  0  0  0  0      0  0  0       0  0  0      0  0  0
--    |      constante    |    |  r2  |      |  r1   |     |opcode| 

-- OPCODE
-- 000 - imediatos soma
-- 001 - imediatos sub
-- 010 - lw, salvar constante
-- 011 (soma = 0) - registradores subtracao
-- 011 (soma = 1) - registradores soma
-- 100 - Branch if equal (com constante)
-- 101 - Branch if equal (com registradores)
-- 110 - Branch para endereco (constante)
-- 111 - Branch relativo (constante)

-- ULA
-- 00 - soma
-- 01 - subtracao
-- 10 - a maior que b
-- 11 - a igual a b

entity UC is
    port(
        instrucao : in unsigned(15 downto 0) := "0000000000000000";
        select_mux_input_regs : out std_logic := '1'; -- 
        select_ula_op : out unsigned(1 downto 0) := "00";
        select_mux_ula : out std_logic := '1'; -- seleciona 1 para constante e 0 para registrador
        instrucao_beq : out std_logic := '1';
        instrucao_salto_relativo : out std_logic := '1';

        reg_wr_en : out std_logic := '1'; 
        selec_reg1 : out unsigned(2 downto 0) := "000";
        selec_reg2 : out unsigned(2 downto 0) := "000";
        registrador_para_salvar : out unsigned(2 downto 0) := "000"
    );
end entity;

architecture a_UC of UC is
    signal select_mux_input_regs_signal : std_logic := '1';
    signal select_ula_op_signal : unsigned(1 downto 0) := "00";
    signal select_mux_ula_signal : std_logic := '0'; -- seleciona 1 para constante e 0 para registrador
    signal instrucao_beq_signal : std_logic := '0';
    signal instrucao_salto_relativo_signal : std_logic := '0';

    signal reg_wr_en_signal : std_logic := '0'; 
    signal selec_reg1_signal : unsigned(2 downto 0) := "000";
    signal selec_reg2_signal : unsigned(2 downto 0) := "000";
    signal registrador_para_salvar_signal : unsigned(2 downto 0) := "000";
    signal opcode : unsigned(2 downto 0) := "000";

    signal tipoI : std_logic := '0';
    signal tipoR : std_logic := '0';
    signal tipoB : std_logic := '0';



    begin
        opcode <= instrucao(2 downto 0);

        tipoR <= '1' when opcode = "011" else '0';
        tipoI <= '1' when opcode = "000" or opcode = "001" or opcode = "010"  else '0';
        tipoB <= '1' when opcode = "100" or opcode = "101" or opcode = "110" or opcode = "111" else '0';

        instrucao_salto_relativo_signal <= '1' when opcode = "111" else '0';

        select_ula_op_signal    <=      "00" when (opcode = "011" and instrucao(15) = '1') or opcode = "000" else
                                        "01" when (opcode = "011" and instrucao(15) = '0') or opcode = "001" else
                                        "11" when opcode = "100" or opcode = "101" or opcode = "110" or opcode = "111" else "00";

        select_mux_ula_signal <=        '1' when opcode = "000" or opcode = "001" 
                                            or opcode = "101" else
                                        '0';

        reg_wr_en_signal <=             '1' when opcode = "000" or opcode = "001" or opcode = "011" else
                                        '0';
        -- por equanti fica esse valor até ter uma RAM
        select_mux_input_regs_signal <= '1';
        -- quando é operacao I ou R salva em um registrador
        registrador_para_salvar_signal <=      instrucao(5 downto 3) when tipoR = '1' or tipoI = '1' else "000";
        -- registrador um a ser operado pela ula
        selec_reg1_signal <=            instrucao(8 downto 6) when tipoR = '1' or tipoI = '1' else
                                        instrucao(5 downto 3) when tipoB = '1' else
                                         "000";
        -- segundo registrador a ser operado
        selec_reg2_signal <=           instrucao(11 downto 9) when tipoR = '1' else
                                        instrucao(8 downto 6) when tipoB ='1' else
                                        "000";
        -- a constante é instanciada pela entidade constante
        -- 
        instrucao_beq_signal <=  '1' when opcode = "100" or opcode = "101" or opcode = "110" else '0';

        select_mux_input_regs <= select_mux_input_regs_signal;
        select_ula_op <= select_ula_op_signal;
        select_mux_ula <= select_mux_ula_signal;
        instrucao_beq <= instrucao_beq_signal;
        reg_wr_en <= reg_wr_en_signal;
        selec_reg1 <= selec_reg1_signal;
        selec_reg2 <= selec_reg2_signal;
        registrador_para_salvar <= registrador_para_salvar_signal;
        instrucao_salto_relativo <= instrucao_salto_relativo_signal;

end architecture;