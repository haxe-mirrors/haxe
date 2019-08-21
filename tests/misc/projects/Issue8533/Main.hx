import haxe.display.Position;
import haxe.macro.Context;
import haxe.macro.PositionTools;

class Main {
	static function main() {
		var s = "待到来年九月八";
		posChecking("我花开后百花杀");
	}

	macro static function posChecking(expr) {
		var info = PositionTools.getInfos(expr.pos);
		var txtPos = PositionTools.make({
			min: info.min,
			max: info.max,
			file: info.file + '.txt'
		});

		var hxLoc = PositionTools.toLocation(expr.pos);
		var txtLoc = PositionTools.toLocation(txtPos);
		if(!equalRanges(hxLoc.range, txtLoc.range)) {
			var msg = 'position numbers should be the same';
			Context.warning(msg, expr.pos);
			Context.error(msg, txtPos);
		}
		return expr;
	}

	static function equalRanges(r1:Range, r2:Range):Bool {
		return equalPositions(r1.start, r2.start) && equalPositions(r1.end, r2.end);
	}

	static function equalPositions(p1:Position, p2:Position) {
		return p1.line == p2.line && p1.character == p2.character;
	}
}
