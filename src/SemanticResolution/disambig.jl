module disambig
export adagramDisambig

using AdaGram

gc_enable(false)
vm, dict = load_model("model/model_output_full.out");

function adagramDisambig(target_word, context)

	counter = 0
	maxval = 0.0
	maxcnt = 0

	arr = disambiguate(vm, dict, target_word, split(context))

	for w in arr
		counter += 1
		if (w > maxval)
			maxval = w
			maxcnt = counter
		end
	end
	return maxcnt
end

end
