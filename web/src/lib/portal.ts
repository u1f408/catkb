export default function portal(node: Node) {
	document.querySelector('main')?.appendChild(node).focus();
}
