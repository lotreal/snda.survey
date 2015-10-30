<li id="Q_<?php echo $cfg['id']; ?>">
    <h3 class="subject"><?php echo $cfg['subject']; ?></h3>
    <table>
        <thead>
            <tr>
                <th>&nbsp;</th>
<?php foreach ( $cfg['options']['col'] as $j => $h ): ?>
                <th><?php echo $h; ?></th>
<?php endforeach; ?>
            </tr>
        </thead>
        <tbody>
<?php foreach ( $cfg['options']['row'] as $k => $v ): ?>
            <tr>
                <th><?php echo $v; ?></th>
<?php if ($cfg['form_type'] == 'radio' || $cfg['form_type'] == 'checkbox'): ?>
<?php foreach ( $cfg['options']['col'] as $j => $h ): ?>
                <td><input type="<?php echo $cfg['form_type']; ?>" name="<?php echo $cfg['id']; ?>[<?php echo $k; ?>][]" id="<?php echo $cfg['id']; ?>_<?php echo $k; ?>_<?php echo $j; ?>" value="<?php echo $j; ?>" /></td>
<?php endforeach; ?>
<?php endif; ?>
            </tr>
<?php endforeach; ?>
        </tbody>
    </table>
</li>