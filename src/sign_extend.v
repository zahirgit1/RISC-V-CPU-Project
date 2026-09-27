module Sign_Extend (In,Imm_Ext,ImmSrc);

    input [31:0]In;
    input  [2:0] ImmSrc;
    output [31:0]Imm_Ext;

    assign Imm_Ext = (ImmSrc == 3'b001) ? ({{20{In[31]}},In[31:25],In[11:7]}):
                     ImmSrc == 3'b000 ? ( {{20{In[31]}},In[31:20]}): 
                     ImmSrc == 3'b010 ? ( {{20{In[31]}},In[7],In[30:25],In[11:8],1'b0} ):
                     ImmSrc == 3'b011 ? ( {{12{In[31]}},In[19:12],In[20],In[30:21],1'b0}):
                     ImmSrc == 3'b100 ? ( {In[31:12],12'b00000000000}):
                      32'b0; // default case, if ImmSrc is not recognized, output 0
                                                                 // 00 for I-Type , 01 for S-Type, 10 for B-Type, 11 for J-Type,100 for U-Type
                                
endmodule