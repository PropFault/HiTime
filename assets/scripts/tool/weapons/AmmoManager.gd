extends Node
class_name AmmoManager
export(int)var rCapacity;
export(int)var rLoaded;
export(int)var rStashed;
export(bool)var reloadOnlyFull = false;


func canReload(var num = -1):
	num = clamp(num,0,rCapacity)
	return rLoaded < rCapacity and ((reloadOnlyFull and rStashed >= num) or (not reloadOnlyFull and rStashed >= 1))

func reload(var num = -1):
	if num < 0:
		num = rCapacity;
	if canReload(num):
		var effectiveRequired = clamp(rLoaded + num, 0, rCapacity);
		rStashed -= effectiveRequired - rLoaded;
		rLoaded = effectiveRequired;

func canSpendBullets(var num = 1):
	return rLoaded >= num

func spendBullets(var num = 1):
	if canSpendBullets(num):
		rLoaded -= num
