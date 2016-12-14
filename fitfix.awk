BEGIN {
    FPAT = "([^,]*)|(\"[^\"]*\")"
}

$0 !~ /unknown/ {
    for (i = 1; i <= NF; i++) {
      if ($(i-1) == "speed") {
        c_speed = unquote($i)
        printf("%s", $i)
      } else if ($(i-1) == "power") {
        c_power = unquote($i)
        printf("\"%s\"", approx(c_speed, c_power, 1))
      } else if ($(i-1) == "cadence") {
        c_cadence = unquote($i)
        printf("\"%s\"", approx(c_speed, c_cadence, 2))
      } else {
      	printf("%s", $i)
      }
      if (i != NF)
        printf(",")
    }
    printf("\n")

    if (c_speed != "") {
      speeds[NR] = c_speed
      powers[NR] = c_power
      cadences[NR] = c_cadence
    }
}

END {
}

function unquote(s) {
	if (substr(s, 1, 1) == "\"") {
	    len = length(s)
	    return substr(s, 2, len - 2)
	} else {
		return s
	}
}

function approx(speed, recorded, type) {
	if ((recorded + 0) > 50.0)
		return recorded
	result = recorded + 0
	for(j in speeds) {
		val = (type == 1 ? powers[j] : cadences[j]) + 0
		if (speeds[j] <= speed && val > 50.0) {
			result = val
		}
	}
	return result
}
