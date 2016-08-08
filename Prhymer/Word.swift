//
//  Word.swift
//  Prhymer
//
//  Created by Thomas Lisankie on 1/12/16.
//  Copyright © 2016 Shaken Earth. All rights reserved.
//

import Foundation

struct Word : PhonemeSequence {
    let wordName: String;
    var listOfPhonemes: [Phoneme];
    var listOfSyllables: [Syllable];
    var numOfSyllables: Int;
    
    init?(wordName: String, phonemeString: String) {
        
        self.wordName = wordName;
        listOfPhonemes = phonemeString.componentsSeparatedByString(" ").map { Phoneme(phonemeName: $0)! }
        listOfSyllables = [Syllable]();
        
        numOfSyllables = 0;
        for phoneme in listOfPhonemes{
            
            if(phoneme.isAVowelPhoneme == true){
                
                numOfSyllables = numOfSyllables + 1;
                
            }
            
            //check for environmentally dependent phoneme changes:
            
        }
        
        print("Number of Syllables in " + wordName + ": ", numOfSyllables);
        
        for (index, phoneme) in listOfPhonemes.enumerate() {
            
            if (index+1 != listOfPhonemes.count) {
                
                if(phoneme.isAVowelPhoneme == true) {
                    
                    if (phoneme.phoneme == "AA" && listOfPhonemes[index+1].phoneme == "R") {
                        
                        listOfPhonemes[index] = Phoneme(phonemeName: "AR")!;
                        listOfPhonemes.removeAtIndex(index+1);
                        
                    }else if (phoneme.phoneme == "EH" && listOfPhonemes[index+1].phoneme == "L") {
                        
                        listOfPhonemes[index] = Phoneme(phonemeName: "EL")!;
                        listOfPhonemes.removeAtIndex(index+1);
                        
                    }else if (phoneme.phoneme == "OW" && listOfPhonemes[index+1].phoneme == "L") {
                        
                        listOfPhonemes[index] = Phoneme(phonemeName: "OL")!;
                        listOfPhonemes.removeAtIndex(index+1);
                        
                    }else if ((phoneme.phoneme == "AO" && listOfPhonemes[index+1].phoneme == "R") || (phoneme.phoneme == "UW" && listOfPhonemes[index+1].phoneme == "R")) {
                        
                        listOfPhonemes[index] = Phoneme(phonemeName: "OR")!;
                        listOfPhonemes.removeAtIndex(index+1);
                        
                    }else if (phoneme.phoneme == "EY" && listOfPhonemes[index+1].phoneme == "L") {
                        
                        listOfPhonemes[index] = Phoneme(phonemeName: "ALE")!;
                        listOfPhonemes.removeAtIndex(index+1);
                        
                    }else if (phoneme.phoneme == "IY" && listOfPhonemes[index+1].phoneme == "R") {
                        
                        listOfPhonemes[index] = Phoneme(phonemeName: "EAR")!;
                        listOfPhonemes.removeAtIndex(index+1);
                        
                    }
                    
                }
                
            }
            
        }
        
        splitIntoSyllables();
        
    }
    
    mutating func splitIntoSyllables() {
        
        var currentSyllable = Syllable();
        var phonemesForCurrentSyllable = [Phoneme]();
        
        var i = 0;
        
        for (index,phonemeBeingExamined) in listOfPhonemes.enumerate() {
            
            if phonemeBeingExamined.isAVowelPhoneme {
                
                if i+1 != listOfPhonemes.count {
                    
                    if listOfPhonemes[i+1].isAVowelPhoneme == false {
                        
                        if i+2 != listOfPhonemes.count - 1 {
                            
                            if phonemeBeingExamined.isALongVowelPhoneme() {
                                
                                phonemesForCurrentSyllable.append(phonemeBeingExamined);
                                currentSyllable = Syllable(listOfPhonemes: phonemesForCurrentSyllable);
                                listOfSyllables.append(currentSyllable);
                                phonemesForCurrentSyllable = [Phoneme]();
                                currentSyllable = Syllable();
                                
                            }else{
                            
                                phonemesForCurrentSyllable.append(phonemeBeingExamined);
                                phonemesForCurrentSyllable.append(listOfPhonemes[i+1]);
                                i = i + 1;
                                currentSyllable = Syllable(listOfPhonemes: phonemesForCurrentSyllable);
                                listOfSyllables.append(currentSyllable);
                                phonemesForCurrentSyllable = [Phoneme]();
                                currentSyllable = Syllable();
                            
                            }
                            
                        }else{
                        
                            if listOfPhonemes[i+2].isAVowelPhoneme == false {
                                
                                phonemesForCurrentSyllable.append(phonemeBeingExamined);
                                phonemesForCurrentSyllable.append(listOfPhonemes[i+1]);
                                phonemesForCurrentSyllable.append(listOfPhonemes[i+2]);
                                i = i + 2;
                                currentSyllable = Syllable(listOfPhonemes: phonemesForCurrentSyllable);
                                listOfSyllables.append(currentSyllable);
                                phonemesForCurrentSyllable = [Phoneme]();
                                currentSyllable = Syllable();
                                
                            }else{
                            
                                phonemesForCurrentSyllable.append(phonemeBeingExamined);
                                currentSyllable = Syllable(listOfPhonemes: phonemesForCurrentSyllable);
                                listOfSyllables.append(currentSyllable);
                                phonemesForCurrentSyllable = [Phoneme]();
                                phonemesForCurrentSyllable.append(listOfPhonemes[i+1]);
                                phonemesForCurrentSyllable.append(listOfPhonemes[i+2]);
                                i = i + 2;
                                currentSyllable = Syllable(listOfPhonemes: phonemesForCurrentSyllable);
                                listOfSyllables.append(currentSyllable);
                                phonemesForCurrentSyllable = [Phoneme]();
                                currentSyllable = Syllable();
                            
                            }
                        
                        }
                        
                    }else{
                    
                        phonemesForCurrentSyllable.append(phonemeBeingExamined);
                        currentSyllable = Syllable(listOfPhonemes: phonemesForCurrentSyllable);
                        listOfSyllables.append(currentSyllable);
                        phonemesForCurrentSyllable = [Phoneme]();
                        currentSyllable = Syllable();
                    
                    }
                    
                }else{
                
                    phonemesForCurrentSyllable.append(phonemeBeingExamined);
                    currentSyllable = Syllable(listOfPhonemes: phonemesForCurrentSyllable);
                    listOfSyllables.append(currentSyllable);
                    phonemesForCurrentSyllable = [Phoneme]();
                    currentSyllable = Syllable();
                
                }
                
            }else{
            
                if i+1 != listOfPhonemes.count {
                    
                    if listOfSyllables.count != 0 {
                        
                        if listOfPhonemes[i+1].isAVowelPhoneme == false {
                            
                            listOfSyllables[listOfSyllables.count - 1].addPhoneme(listOfPhonemes[i]);
                            
                        }else{
                        
                            phonemesForCurrentSyllable.append(phonemeBeingExamined);
                        
                        }
                        
                    }else{
                    
                        phonemesForCurrentSyllable.append(phonemeBeingExamined);
                    
                    }
                    
                }else{
                
                    phonemesForCurrentSyllable.append(phonemeBeingExamined);
                
                }
            
            }
            
            if index == 0 {
                i = index;
            }else{
                
                i = i + 1;
                
            }
            
        }
        
        for phoneme in phonemesForCurrentSyllable {
            
            listOfSyllables[listOfSyllables.count - 1].addPhoneme(phoneme);
            
        }
        
        listOfPhonemes = [Phoneme]();
        
    }
    
    init?(line: String) {
        
        let components = line.componentsSeparatedByString("  ")
        guard components.count == 2 else { return nil }
        
        wordName = components[0].lowercaseString;
        listOfPhonemes = components[1].componentsSeparatedByString(" ").map { Phoneme(phonemeName: $0)! }
        listOfSyllables = [Syllable]();
        
        numOfSyllables = 0;
        for phoneme in listOfPhonemes{
        
            if(phoneme.isAVowelPhoneme == true){
            
                numOfSyllables = numOfSyllables + 1;
            
            }
        
        }
        
    }
    
    init() {
        wordName = "";
        listOfPhonemes = [Phoneme]();
        listOfSyllables = [Syllable]();
        numOfSyllables = 0;
    }
    
    init?(wordName: String, phonemes: [Phoneme]) {
        
        self.wordName = wordName;
        self.listOfPhonemes = phonemes;
        listOfSyllables = [Syllable]();
        
        numOfSyllables = 0;
        for phoneme in listOfPhonemes{
            
            if(phoneme.isAVowelPhoneme == true){
                
                numOfSyllables = numOfSyllables + 1;
                
            }
            
        }
        
    }
    
}
