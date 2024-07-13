/**
 * cf. https://qiita.com/mimoe/items/855c112625d39b066c9a
 */
export const hiraganaToKatakana = (hiragana: string): string => {
  return hiragana.replace(/[\u3041-\u3096]/g, function(match) {
    const chr = match.charCodeAt(0) + 0x60;
    return String.fromCharCode(chr);
});
}