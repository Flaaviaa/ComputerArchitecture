library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- tem que configurar o wr_en pra quando for para o acc e para o banco de regs

-- 
entity UC is
    port(
        instrucao : in unsigned(15 downto 0) := "0000000000000000";
        rst : in std_logic := '0';
        -- PC
        instrucao_branch : out std_logic := '0';
        instrucao_jump : out std_logic := '0';
        select_mux_pc : out unsigned(1 downto 0) := "00";
        wr_en_pc : out std_logic := '1';
        -- ULA
        select_ula_op : out unsigned(1 downto 0) := "00";
        select_mux_ula : out std_logic := '0'; -- seleciona 1 para constante e 0 para registrador
        -- REG
        reg_wr_en : out std_logic := '1'; 
        selec_reg1 : out unsigned(2 downto 0) := "000";
        selec_reg2 : out unsigned(2 downto 0) := "000";
        registrador_para_salvar : out unsigned(2 downto 0) := "000";
        select_mux_input_regs : out std_logic := '1';
        -- ACC
        acc_wr_en : out std_logic := '0';
        select_mux_acc : out unsigned(1 downto 0) := "00";
        -- ERROS
        erro_instrucao : out unsigned(3 downto 0) := "0000";
        brake : out std_logic := '0';
        -- REG FLAGS E REGISTRADOR DA ULA
        regflags_wr_en : out std_logic := '0';
        regula_wr_en : out std_logic := '0';
        -- RAM
        ram_wr_en : out std_logic
    );
end entity;

architecture a_UC of UC is
    signal select_mux_input_regs_signal : std_logic := '1';
    signal select_ula_op_signal : unsigned(1 downto 0) := "00";
    signal select_mux_ula_signal : std_logic := '0'; -- seleciona 1 para constante e 0 para registrador
    signal instrucao_branch_signal : std_logic := '0';

    signal selec_reg1_signal : unsigned(2 downto 0) := "000";
    signal opcode : unsigned(2 downto 0) := "000";

    signal sistema : std_logic := '0';
    signal add : std_logic := '0';
    signal addi : std_logic := '0';
    signal sub : std_logic := '0';
    signal mov : std_logic := '0';
    signal ld : std_logic := '0';
    signal jump : std_logic := '0';
    signal branch : std_logic := '0';
    signal comparar : std_logic := '0';
    signal lw : std_logic := '0';
    signal sw : std_logic := '0';

    signal reg_on : std_logic := '0';
    signal acc_on : std_logic := '0';
    begin
        opcode <= instrucao(15 downto 13);

        -- instrucoes 
            sistema <= '1' when opcode = "000" else '0';
            add <= '1' when opcode = "001" and instrucao(11) = '0' else '0';
            addi <= '1' when opcode = "010" else '0';
            sub <= '1' when opcode = "001" and instrucao(11) = '1' else '0';
            mov <= '1' when opcode = "100" else '0';
            ld <= '1' when opcode = "101" else '0';
            jump <= '1' when opcode = "110" and instrucao(12) = '0' else '0';
            branch <= '1' when opcode = "110" and instrucao(12) = '1' else '0';
            comparar <= '1' when opcode = "111" else '0';
            lw <= '1' when opcode = "011" and instrucao(11) = '0' else '0';
            sw <= '1' when opcode = "011" and instrucao(11) = '1' else '0';

            selec_reg2 <= instrucao(10 downto 8) when lw = '1' or sw = '1' else "000";

            instrucao_branch <= branch;
            instrucao_jump <= jump;
            regflags_wr_en <= '1' when comparar = '1' or add = '1' or addi = '1' or sub = '1';
            regula_wr_en <= '1' when add = '1' or addi = '1' or sub = '1' else '0';

            brake <=    '1' when sistema = '1' and instrucao(12 downto 10) > "000" else '0';


            reg_wr_en <=    '1' when mov = '1' and instrucao(8) = '0' else
                            '1' when ld = '1' and instrucao(8) = '0' else
                            '0';

            acc_wr_en <=    '1' when mov = '1' and instrucao(8) = '1' else
                            '1' when ld = '1' and instrucao(8) = '1' else
                            '1' when add = '1' or addi = '1' or sub = '1' else
                            '0';

            select_mux_input_regs <= '1' when ld = '1' else '0';
            
            select_ula_op <=    "00" when add = '1' else
                                "01" when sub = '1' else
                                "10" when comparar = '1' and instrucao(10) = '1' else
                                "11" when comparar = '1' and instrucao(10) = '0' else "00";

            select_mux_ula <=   '1' when addi = '1' or (comparar = '1' and instrucao(11 downto 10) = "00") else '0';

            select_mux_acc <=   "00" when mov = '1' else
                                "10" when ld = '1' else
                                "01" when add = '1' or addi = '1' or sub = '1' else "00";
            
            select_mux_pc <=    instrucao(11 downto 10) when jump = '1' or branch = '1' else "00";

            selec_reg1 <=       instrucao(11 downto 9) when add = '1' or addi = '1' or sub = '1' or mov = '1' or ld = '1'else
                                instrucao(9 downto 7) when comparar = '1' and instrucao(11 downto 10) = "01" else
                                "000";

            registrador_para_salvar <= instrucao(11 downto 9) when mov = '1' or ld = '1' else "000";
            ram_wr_en <= sw;
            
        -- erros de opcode
            erro_instrucao <=   "0001" when sistema ='1' and instrucao(8 downto 0) > B"000_000_000" else
                                "0010" when add ='1' and instrucao(8 downto 6) > "000" else
                                "0011" when addi ='1' and instrucao(11 downto 8) > "0000" else
                                "0100" when sub ='1' and instrucao(8 downto 6) > "000" else
                                "0101" when mov ='1' and instrucao(7 downto 0) > B"0000_0000" else
                                "0110" when ld ='1' and (instrucao(12) = '1' and instrucao(11 downto 9) > "000")else
                                "0111" when jump ='1' and instrucao(9 downto 7) > "000" else
                                "1000" when branch ='1' and instrucao(9 downto 7) > "000" else
                                "1001" when comparar ='1' and (instrucao(10 downto 7) > "0000")else
                                "1010" when (lw = '1' or sw = '1') and (instrucao(6 downto 0) > "0000000" or instrucao(12 downto 11) > "01") else
                                "0000";

            brake <= '1' when sistema = '1' and instrucao(12 downto 10) = "011" else '0';


end architecture;