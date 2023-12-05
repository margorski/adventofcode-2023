#!/usr/bin/env node
"use strict";

const fs = require('fs');
const readline = require('readline');

function calculateCardPoints(card) {
    const matchingNumbers = card.numbers.filter(n => card.winningNumbers.includes(n));
    return matchingNumbers.length;
}

function mapCard(line) {
    return {
        id: parseInt(line.match(/(\d+):/)[0]),
        winningNumbers: [...line.split(':')[1].split('|')[0].matchAll(/\b(\d+)\b/g)].map(m => parseInt(m[0])),
        numbers: [...line.split(':')[1].split('|')[1].matchAll(/\b(\d+)\b/g)].map(m => parseInt(m[0]))
    };
}

async function solvePuzzleForFile(filename) {
    const fileStream = fs.createReadStream(filename);
  
    const rl = readline.createInterface({
      input: fileStream,
      crlfDelay: Infinity
    });
    
    const originalCards = [];
    for await (const line of rl) originalCards.push(mapCard(line));

    const solveCard = (card) => {
        const points = calculateCardPoints(card);
        const startIdx = card.id;
        const endIdx = card.id + points;
        const copiedCards = originalCards.slice(startIdx, endIdx);
        return [card, ...copiedCards.flatMap(solveCard)];
    }

    const allCards = originalCards.flatMap(solveCard);

    return allCards.length;
}

async function verifyForTestData() {
    const assert = require('assert');
    const testdataFilename = './testdata.txt';
    const testdataResult = 30;

    assert(testdataResult === await solvePuzzleForFile(testdataFilename), 'sum for testdata is not correct');
    console.log("Solution verified with test data verified.");
}

verifyForTestData();
const inputFilename = process.argv.slice(2, 3)?.[0];

if (!inputFilename) {
    console.error("Provide input filename. Leaving.");
    return 1;
}

solvePuzzleForFile(inputFilename).then(result => console.log(`Result: ${result}`));
