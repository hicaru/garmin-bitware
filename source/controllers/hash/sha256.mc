
class Hash {
	private const _block;
	private const _finalSize;
	private const _blockSize;
	private const _len = 0;

	public function initialize(blockSize, finalSize) {
		self._blockSize = blockSize;
		self._finalSize = finalSize;
		self._block = new [blockSize];
	}

	public function update(data) {
		var block = self._block;
		var blockSize = self._blockSize;
		var length = data.length;
		var accum = self._len;
	}
}

class Sha256 {
}
