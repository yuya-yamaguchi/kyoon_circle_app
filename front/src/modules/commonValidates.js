const REGEXP = /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}\.[A-Za-z0-9]{1,}$/;
const EMPTY_ERR        = "入力してください"
const LENGTH_OVER_ERR  = "文字以内で入力してください"
const EMAIL_FORMAT_ERR = "メールアドレスの形式が正しくありません"
const NOT_MATCH_ERR    = "値が一致していません"

/* 必須チェック */
export function notEmptyValid(value) {
  if (!value) return EMPTY_ERR
  return ''
}
/* 最大文字数チェック */
export function maxLengthValid(value, maxLength) {
  if (value && value.length > maxLength) return `${maxLength}${LENGTH_OVER_ERR}`
  return ''
}
/* 最大最小文字数チェック */
export function rangeLengthValid(value, minLength, maxLength) {
  if (value && (value.length < minLength || value.length > maxLength)) return `${minLength}文字から${maxLength}文字で入力してください`
  return ''
}
/* メールフォーマットチェック */
export function emailFormatValid(value) {
  if (!REGEXP.test(value)) return EMAIL_FORMAT_ERR
  return ''
}
/* 値の一致チェック */
export function matchValid(value1, value2) {
  if (value1 != value2) return NOT_MATCH_ERR
  return ''
}