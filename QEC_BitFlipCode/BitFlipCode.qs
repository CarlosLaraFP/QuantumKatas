namespace Microsoft.Quantum.Katas.QEC {
    //
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;

    operation Encode (register : Qubit[]) : Unit {
        // This entangles the 3 qubits
        Message("Entangling 3 qubits...");
        ApplyToEachCA(CNOT(Head(register), _), Rest(register));
    }

    operation PrepareRegister () : Qubit[] {
        //
        use register = Qubit[3];
        H(Head(register));
        Encode(register);
        return register;
    }

    operation NoiseChannel (register : Qubit[], errorIndex : Int) : Unit is Adj + Ctl {
        //
        X(register[errorIndex]);
    }

    operation MeasureParity (register : Qubit[]) : Result {
        // 
        let pauliBases = [PauliZ, size = Length(register)];
        return Measure(pauliBases, register);
    }

    operation DetectErrorOnAnyQubit (register : Qubit[]) : Int {
        //
        let firstCheck = MeasureParity(Most(register));
        let secondCheck = MeasureParity(Rest(register));

        return firstCheck == Zero ? secondCheck == Zero ? 0 | 3
                                  | secondCheck == Zero ? 1 | 2;
    }

    operation CorrectErrorOnAnyQubit (register : Qubit[]) : Unit {
        //
        let errorIndex = DetectErrorOnAnyQubit(register);

        if (errorIndex > 0) { 
            X(register[errorIndex - 1]);
        }
    }

    @Test("QuantumSimulator")
    operation TestBitFlipQEC () : Unit {
        //
        let register = PrepareRegister();
        let flipIndex = 1;

        NoiseChannel(register, flipIndex);

        let qubitFlipped = DetectErrorOnAnyQubit(register);
        Fact(qubitFlipped == flipIndex + 1, $"{qubitFlipped} did not match {flipIndex + 1}");
        Message($"{qubitFlipped} matched {flipIndex + 1}");

        CorrectErrorOnAnyQubit(register);
        
        let qubitCorrected = DetectErrorOnAnyQubit(register);
        Fact(qubitCorrected == 0, $"{qubitCorrected} did not match input state.");
        Message($"{qubitCorrected} matched input state.");

        ResetAll(register);
    }
}