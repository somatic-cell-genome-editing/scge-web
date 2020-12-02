<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/8/2020
  Time: 12:09 PM
  To change this template use File | Settings | File Templates.
--%>
<div class="container">
    <h4>Experiment Details</h4>

    <form>
        <label>
            Experiment Name:
            <input type="text">
        </label>
        <label>
            Experiment Type:
            <select>
                <option>In Vivo</option>
                <option>In Vitro</option>
                <option>Cell culture</option>
            </select>

        </label>
        <label>
            Access
            <select>
                <option>TIER-1 (Project Group + DCC + NIH)</option>
                <option>TIER-2 (Project Group+ Working Group + DCC + NIH)</option>
                <option>TIER-3 (Whole Consortium)</option>
                <option>TIER-4 (Public)</option>
            </select>
        </label>
        <button>Back</button>  <button>Save & Continue</button>

    </form>
</div>
