<li id="Q_<?php echo $cfg['id']; ?>">
    <h3 class="subject"><?php echo $cfg['subject']; ?></h3>
    <table>
<?php if ($cfg['form_type'] == 'radio' || $cfg['form_type'] == 'checkbox'): ?>
<?php foreach ( $cfg['options'] as $k => $v ): ?>
        <tr>
            <td>
                <input type="<?php echo $cfg['form_type']; ?>" name="<?php echo $cfg['id']; ?>[choice][]" id="<?php echo $cfg['id']; ?>_<?php echo $k; ?>" value="<?php echo $k; ?>" /><?php echo $v; ?>
                
<?php if ( isset($cfg['allow_specify']) && in_array($k, $cfg['allow_specify']) ) : ?>
                <input type="text" name="<?php echo $cfg['id']; ?>[specify][<?php echo $k; ?>]" id="<?php echo $cfg['id']; ?>_<?php echo $k; ?>_specify" />
                
<?php endif; ?>
            </td>
        </tr>
<?php endforeach; ?>
<?php elseif($cfg['form_type'] == 'select'): ?>
        <tr>
            <td>
                <select name="<?php echo $cfg['id']; ?>[choice][]">
<?php foreach ( $cfg['options'] as $k => $v ): ?>
                    <option id="<?php echo $cfg['id']; ?>_<?php echo $k; ?>" value="<?php echo $k; ?>"><?php echo $v; ?></option>
<?php endforeach; ?>
                </select>
            </td>
        </tr>
<?php endif; ?>
    </table>
</li>
