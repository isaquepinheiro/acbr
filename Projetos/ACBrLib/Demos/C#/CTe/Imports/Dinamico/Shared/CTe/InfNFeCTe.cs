﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ACBrLib.Core.CTe
{
    public class InfNFCTe
    {
        public string nRoma { get; set; }

        public string nPed { get; set; }

        public int mod { get; set; }

        public string serie { get; set; }

        public string nDoc { get; set; }

        public DateTime dEmi { get; set; }

        public decimal vBC { get; set; }

        public decimal vICMS { get; set; }

        public decimal vBCST { get; set; }

        public decimal vST { get; set; }

        public decimal vProd { get; set; }

        public decimal vNF { get; set; }

        public int nCFOP { get; set; }

        public decimal? nPeso { get; set; }

        public string chave { get; set; }

        public string PIN { get; set; }

        public DateTime? dPrev { get; set; }

        public List<InfUnidCargaCTe> infUnidCarga { get; } = new List<InfUnidCargaCTe>();

        public List<InfUnidTranspCTe> infUnidTransp{ get; } = new List<InfUnidTranspCTe>();
    }
}
