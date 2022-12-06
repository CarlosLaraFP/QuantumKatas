namespace Quantum.Kata.QEC_BitFlipCode {
    //
    open Microsoft.Quantum.Katas.QEC;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;

    @EntryPoint()
    operation Program () : Unit {
        // List steps required

        // Prepare input state
        // Encode in +2 auxiliary qubits
        // Send through error-inducing (noisy) channel
        // Detect single-qubit flip (Syndrome)
        // Correct single-qubit error (Recovery)
        // Decode to recover original input state

        Message("Testing QEC...");
        TestBitFlipQEC();
        Message("Success");
    }
}