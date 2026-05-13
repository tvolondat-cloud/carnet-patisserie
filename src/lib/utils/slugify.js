/**
 * Convertit un nom de recette en slug URL-safe.
 * Ex: "Crème pâtissière" → "creme-patissiere"
 *     "Pâte à choux"     → "pate-a-choux"
 *     "Éclair café"      → "eclair-cafe"
 */
export function slugify(str) {
	return (str ?? '')
		.toLowerCase()
		.replace(/œ/g, 'oe')
		.replace(/æ/g, 'ae')
		.normalize('NFD')
		.replace(/[̀-ͯ]/g, '') // supprime les diacritiques
		.replace(/[^a-z0-9]+/g, '-')
		.replace(/^-+|-+$/g, '');
}
