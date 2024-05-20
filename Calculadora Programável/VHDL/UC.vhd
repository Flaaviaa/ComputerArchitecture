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
-- 100 - Branch if not equal (com constante)
-- 101 - Branch if not equal (com registradores)
-- 110 - Branch para endereco (constante)
-- 111 - Branch relativo (constante)

-- ULA
-- 00 - soma
-- 01 - subtracao
-- 10 - a maior que b
-- 11 - a igual a b

entity UC is
    port(
        instrucao : in unsigned(15 downto 0);
        select_mux_input_regs : out std_logic; -- 
        select_ula_op : out unsigned(1 downto 0);
        select_mux_ula : out std_logic; -- seleciona 1 para constante e 0 para registrador
        instrucao_beq : out std_logic;

        reg_wr_en : out std_logic; 
        wr_reg_andress : out unsigned(2 downto 0);
        selec_reg1 : out unsigned(2 downto 0);
        selec_reg2 : out unsigned(2 downto 0);
        registrador_para_salvar : out unsigned(2 downto 0)
    );
end entity;

architecture a_UC of UC is
    signal reg_wr_en_signal : std_logic; 
    signal select_mux_input_regs_signal : std_logic;
    signal select_ula_op_signal : unsigned(1 downto 0);
    signal select_mux_ula_signal : std_logic; -- seleciona 1 para constante e 0 para registrador
    signal instrucao_beq_signal : std_logic;

    signal reg_wr_en : std_logic; 
    signal wr_reg_andress_signal : unsigned(2 downto 0);
    signal selec_reg1_signal : unsigned(2 downto 0);
    signal selec_reg2_signal : unsigned(2 downto 0)
    signal registrador_para_salvar : unsigned(2 downto 0);
    signal opcode : unsigned(2 downto 0);

    signal tipoI : std_logic := '0';
    signal tipoR : std_logic := '0';
    signal tipoB : std_logic := '0';


    signal delta_salto_branch_signal : unsigned(6 downto 0);
    signal constante_ula_signal : unsigned(15 downto 0);

    


    begin
        opcode <= instrucao(2 downto 0);

        tipoR <= '1' when opcodepart = "011" else '0';
        tipoI <= '1' when opcodepart = "000" or opcodepart = "001" or opcodepart = "010"  else '0';
        tipoB <= '1' when opcodepart = "100" or opcodepart = "101" or opcodepart = "110" or opcodepart = "111" else '0';

        select_ula_op_signal    <=      "00" when opcode = "011" and instrucao(15) = '1' else
                                        "01" when opcode = "011" and instrucao(15) = '0' else
                                        "10" when opcode = "100" or opcode = "101" else "11";

        select_mux_ula_signal <=        '1' when opcode = "000" or opcode = "001" 
                                            or opcode = "101" or opcode = "110" else
                                        '0';

        reg_wr_en_signal <=             '1' when opcode = "000" or opcode = "001" or opcode = "011" else
                                        '0';
        -- o endereço que vai ser escrito o valor na entrada do registrador
        wr_reg_andress_signal <=        instrucao(5 downto 3) when opcode = "000" or opcode = "001" or opcode = "011" else
                                        "000";
        -- por equanti fica esse valor até ter uma RAM
        select_mux_input_regs_signal <= '1';
        -- quando é operacao I ou R salva em um registrador
        registrador_para_salvar <=      instrucao(5 downto 3) when tipoR = '1' or tipoI = '1' else "000";
        -- registrador um a ser operado pela ula
        selec_reg1_signal <=            instrucao(8 downto 6) when tipoR = '1' or tipoI = '1' else
                                        instrucao(5 downto 3) when tipoB = '1' else
                                         "000";
        -- segundo registrador a ser operado
        select_reg2_signal <=           instrucao(11 downto 9) when tipoR = '1' else
                                        instrucao(8 downto 6) when tipoB ='1' else
                                        "000";
        -- a constante é instanciada pela entidade constante
        -- 


end architecture;